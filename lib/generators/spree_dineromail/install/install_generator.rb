module SpreeDineromail
	module Generators
		class InstallGenerator < Rails::Generators::Base
			def create_initializer_files
				create_file("config/dineromail.yml",
				"development:
    checkout_url: http://localhost:4000/integration_requests
    ipn_url: http://localhost:4000/queries
staging:
    checkout_url: http://localhost:4000/integration_requests
    ipn_url: http://localhost:4000/queries
production:
    checkout_url: https://chile.dineromail.com/Vender/ConsultaPago.asp
    ipn_url: https://chile.dineromail.com/Vender/ConsultaPago.asp")

				create_file "config/initializers/dineromail.rb",
				"DINEROMAIL = YAML.load_file(\"\#{Rails.root}/config/dineromail.yml\")[Rails.env]"
			end
		end
	end
end
