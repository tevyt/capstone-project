class ApplicationController <ActionController::API
	before_action :check_user_exists, only: [:test]

	def test
		return :ok
	end

	protected
		def check_user_exists
			@currentUser = User.where(email: params[:email], password: params[:password]).take
		end
end
