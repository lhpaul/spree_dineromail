# -*- encoding : utf-8 -*-
module Spree
  class DineromailController < Spree::BaseController
    before_filter :get_order

    def success
      advance_state
      redirect_to order_path(:id => @order.number), :notice => Spree.t(:order_processed_successfully)
    end

    def pending
      advance_state
      redirect_to order_path(:id => @order.number), :notice => Spree.t(:order_processed_successfully)
    end

    def failure
      flash[:error] = I18n.t(:dm_payment_failure)
      redirect_to checkout_state_path(@order.state)
    end

    def pay
      render :layout => false
    end

    private
    def correct_order_state
      (@order.state == 'payment' || @order.state == 'complete') &&
      @order.payments.last.payment_method &&
      (@order.payments.last.payment_method.type == "Spree::PaymentMethod::Dineromail")
    end

    def advance_state
      @order.update_attributes( { :state => "complete", :completed_at => Time.now },
      :without_protection => true)
      @order.finalize!
    end

    def get_order
      user = spree_current_user
      order_no = params[:order_number]
      @order = Order.where(number: order_no).where(user_id: user.id).first
      unless @order && correct_order_state
        if @order.present?
          redirect_to checkout_state_path(@order.state)
        else
          flash[:error] = I18n.t(:dm_invalid_order)
          redirect_to root_path
        end
        return
      end
    end
  end
end