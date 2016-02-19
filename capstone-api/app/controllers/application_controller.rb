class ApplicationController <ActionController::API
    before_action :check_user_exist, only: [:test]

    def test
        return :ok
    end


    protected
    def check_user_exist
        @currentUser = User.where(email: params[:email],password: params[:password]).take
    end


end
