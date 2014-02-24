# -*- encoding : utf-8 -*-
module Spree
  class PaymentMethod::Dineromail < PaymentMethod
    attr_accessible :preferred_dineromail_email, :preferred_seller_name, :preferred_country_id, :preferred_payment_methods

    preference :dineromail_email, :string
    preference :seller_name, :string
    preference :country_id, :integer
    preference :payment_methods, :string

    def payment_profiles_supported?
      false
    end

    def actions
      %w{capture void}
    end

    # Indicates whether its possible to capture the payment
    def can_capture?(payment)
      ['checkout', 'pending'].include?(payment.state)
    end

    # Indicates whether its possible to void the payment.
    def can_void?(payment)
      payment.state != 'void'
    end

    def capture(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end

    def void(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end
  end
end