Rails.application.routes.draw do
  get 'survey/show'
  post 'survey/submit' => 'survey#create_response'
  get 'survey/complete'

  root 'survey#show'
end
