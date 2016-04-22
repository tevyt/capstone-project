class ApplicationController <ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate, only: [:test]

  def test
    return :ok
  end

  protected
  def authenticate
    authenticate_token || error_message(:unauthorized)
  end

  def authenticate_token
    authenticate_with_http_token do |token, options|
      @current_user = User.find_by(auth_token: token)
    end
  end

  def error_message(status_code, errors=[])
    error = case status_code
            when :not_found
              {'error' => 'Resource not found'}.to_json 
            when :bad_request
              errors
            when :unauthorized
              self.headers['WWW-Authenticate'] = 'Token realm="Application"'
              {error: 'Bad Credentials'}
            end
    render json: {errors: error}, status: status_code
  end

  def authorized?(user)
    @current_user == user 
  end

end
