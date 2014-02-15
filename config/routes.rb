Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  scope "/dineromail", controller: :dineromail do
  	get :pay, as: :dineromail_pay
    get :success, as: :dineromail_success
    get :pending, as: :dineromail_pending
    get :failure, as: :dineromail_failure
  end
end
