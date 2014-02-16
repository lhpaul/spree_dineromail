Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  scope "/dineromail", controller: :dineromail do
    get :success, as: :dineromail_success
    get :pending, as: :dineromail_pending
    get :failure, as: :dineromail_failure
    post :ipn, as: :dineromail_ipn
  end
end
