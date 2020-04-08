class UsersController < ApplicationController

    def new        
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save then
            session[:user_id] = @user.id
            redirect_to mazes_path
        else
            flash[:error] = "could not create this user"
            redirect_to new_user_path
        end
    end
    
    private
    
    def user_params
        params.require(:user).permit(:name, :password, :password_confirmation)
    end

end
