class ApplicationController <ActionController::API
  before_action :check_user_exists, only: [:test]

  def test
    return :ok
  end

  protected
  def check_user_exists
    @currentUser = User.where(email: params[:email], password: params[:password]).take
  end

  def error_message(status_code, errors=[])
    error = case status_code
            when :not_found
              {'error' => 'Resource not found'}.to_json 
            when :bad_request
              errors.to_json
            end
    render json: error, status: status_code
  end
end
