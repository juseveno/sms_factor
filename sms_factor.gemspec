# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name          = 'sms_factor'
  s.version       = '0.2.2'
  s.date          = '2015-07-17'
  s.summary       = "An easy way to send SMS through SmsFactor API"
  s.description   = "An easy way to use API SMS of http://www.smsfactor.com/ (http://www.smsfactor.com/api-sms)"
  s.authors       = ["Julien Séveno"]
  s.email         = 'jseveno@gmail.com'
  s.files         = [
                      "lib/sms_factor.rb",
                      "lib/sms_factor/configuration.rb",
                      "lib/sms_factor/init.rb",
                      "lib/sms_factor/sms_response.rb"
                    ]
  s.homepage      = 'https://github.com/juseveno/sms_factor'
  s.licenses      = ["LGPL"]
  s.require_paths = ["lib"]
  s.extra_rdoc_files = ["LICENSE.txt", "README.rdoc"]
  s.add_runtime_dependency "rest-client", '~> 2.0.2', '>= 2.0.2'
  s.required_ruby_version = '>= 2.2.0'
  s.requirements << 'rest-client, >= 2.0.2'
  s.requirements << 'An account on http://www.smsfactor.com/'
end
