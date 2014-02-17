SpreeDineromail
===============

This gems adds Dineromail payment method. Its based on the [nicolas-simplex / dineromail](https://github.com/jstnn/spree_dineromail "nicolas-simplex / dineromail")

Installation
------------

Add spree_dineromail to your Gemfile:

```ruby
gem 'spree_dineromail', :git => 'https://github.com/lhpaul/spree_dineromail'
```
Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_dineromail:install
```
You configurate the gem to work with [dinero_mail_fake_ipn](https://github.com/code54/dinero_mail_fake_ipn "dinero_mail_fake_ipn")
```yml
## config/dineromail.yml
development:
    checkout_url: http://localhost:4000/integration_requests
    ipn_url: http://localhost:4000/queries
staging:
    checkout_url: http://localhost:4000/integration_requests
    ipn_url: http://localhost:4000/queries
production:
    checkout_url: https://chile.dineromail.com/Vender/ConsultaPago.asp
    ipn_url: https://chile.dineromail.com/Vender/ConsultaPago.asp
```

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

```shell
bundle
bundle exec rake test_app
bundle exec rspec spec
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_dineromail/factories'
```

Copyright (c) 2014 Luis Hernan Paul, released under the New BSD License
