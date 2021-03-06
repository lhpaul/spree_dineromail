# -*- encoding : utf-8 -*-
module Spree
  class DineromailController < Spree::BaseController
    before_filter :get_order, :except => [:ipn]

    def success
      advance_state
      @order.payments.each do |p|
        p.started_processing
      end
      redirect_to order_path(:id => @order.number), :notice => Spree.t(:order_processed_successfully)
    end

    def pending
      advance_state
      @order.payments.each do |p|
        p.started_processing
      end
      redirect_to order_path(:id => @order.number), :notice => Spree.t(:order_processed_successfully)
    end

    def failure
      flash[:error] = I18n.t(:dm_payment_failure)
      redirect_to checkout_state_path(@order.state)
    end

    def ipn
      notifications = Dineromail::Notification.parse(params["Notificacion"])
      notifications.each do |notify|
        if notify.valid_report?
          order = Order.find_by_number(notify.transaction_id)
          if notify.completed?
            order.payments.last.complete
          elsif notify.pending?
            order.payments.last.pend
          elsif notify.cancelled?
            order.payments.last.failure
          end
          order.save
        end
      end
      render :nothing => true
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