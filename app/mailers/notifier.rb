class Notifier < ActionMailer::Base
  default from: "demo_app@pomodoro.nl"
  default to: "demo_app@pomodoro.nl"

  def response(response)
    @response = response
    mail(subject: "new survey from #{@response.email}")
  end
end
