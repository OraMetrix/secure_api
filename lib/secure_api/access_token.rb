module SecureApi
  module AccessToken
    def self.included(base)
      base.before_action :authorize_by_access_token
    end

    private
      def authorize_by_access_token
        unless ApiToken.valid?(params[:access_token])
          logger.error 'API TOKEN EXCEPTION: invalid access_token'
          head :unauthorized 
        end
      end
  end
end