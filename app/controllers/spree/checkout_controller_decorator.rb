# -*- encoding : utf-8 -*-
Spree::CheckoutController.class_eval do
  before_filter :redirect_to_dineromail_if_needed, :only => [:update]

  def redirect_to_dineromail_if_needed
    return unless params[:state] == "payment"

    selected_method_id = params[:order][:payments_attributes].first[:payment_method_id]
    @payment_method = Spree::PaymentMethod.find(selected_method_id)

    if @payment_method && @payment_method.kind_of?(Spree::PaymentMethod::Dineromail)
      @order.update_attributes(object_params)
      redirect_to dineromail_pay_path(:order_number => @order.number)
    end
  end
end