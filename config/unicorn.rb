app_name = "demo_app"
app_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

# Only necessary when the app dir gets changed on new releases, see:
# http://www.justinappears.com/blog/2-no-downtime-deploys-with-unicorn/

# Unicorn::HttpServer::START_CTX[0] = "#{app_root}/bin/unicorn"
#
# before_exec do |server|
#   ENV["BUNDLE_GEMFILE"] = "#{app_root}/Gemfile"
# end

working_directory app_root

pid "#{app_root}/tmp/pids/unicorn.pid"
stderr_path "#{app_root}/log/unicorn.log"
stdout_path "#{app_root}/log/unicorn.log"

listen "/tmp/unicorn.#{app_name}.sock"

worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout Integer(ENV.fetch('WEB_TIMEOUT', 20))

preload_app true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  # This allows a new master process to incrementally
  # phase out the old master process with SIGTTOU to avoid a
  # thundering herd (especially in the "preload_app false" case)
  # when doing a transparent upgrade.  The last worker spawned
  # will then kill off the old master process with a SIGQUIT.
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
