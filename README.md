# SecureApi

This gem creates and validates a url_safe token used to authorize access to an api.

## Installation

Have include the raw gem in your vendor folder

    gem unpack secure_api --target vendor/gems

Add it to your gemfile

    gem 'secure_api', :path => "vendor/gems/secure_api-VERSION"

And then execute:

    $ bundle

## Usage

To authenticate access for an api controller, include SecureApi::AccessToken

    class ApiController << ApplicationController
      include SecureApi::AccessToken
    
    end

To create an access token 

    ApiToken.create

Be sure to include it as a param

    data = JSON.generate({ :method => method, :args => args, :access_token => ApiToken.create })
    response = RestClient.post(url, data,
      :content_type => 'application/json',
      :cookies => request.cookies)