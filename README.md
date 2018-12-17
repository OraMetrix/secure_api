# SecureApi

This gem creates and validates a url_safe token used to authorize access to an api.

## Installation

Have include the raw gem in your vendor folder

    gem unpack secure_api --target vendor/gems

Add the gem to your `Gemfile`.

    gem 'secure_api', path: 'vendor/gems/secure_api-VERSION'
    gem 'secure_api', git: 'https://github.com/OraMetrix/secure_api.git', branch: 'master'

And then execute:

    $ bundle

## Usage

Configure the gem for your Rails app.

```.rb
# config/initializers/secure_api.rb
SecureApi.configure do |config|
  config.secure_api_pass_phrase = 'some top secret pass phrase'
  config.secure_api_salt = 'some salt' # must be 16 bytes long
end
```

To authenticate access for an api controller, include SecureApi::AccessToken

```.rb
class ApiController << ApplicationController
  include SecureApi::AccessToken

end
```

To create an access token 

```.rb
ApiToken.create
```

Be sure to include it as a param

```.rb
data = JSON.generate({method: method, args: args, access_token: ApiToken.create})
response = RestClient.post(url, data,
  content_type: 'application/json',
  cookies: request.cookies)
```
