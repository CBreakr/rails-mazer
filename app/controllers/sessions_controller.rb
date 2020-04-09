class SessionsController < ApplicationController

    def new
        @user = User.new
    end

    def create
        # if !session.has_key?(:login_attempts) then
        #     session[:login_attempts] = 1
        # else
        #     session[:login_attempts] += 1
        # end

        # if session[:login_attempts] >= limit then
        #     login_limit_reached
        #     return
        # end

        @user = User.find_by(name: session_params[:name])
        if @user && @user.authenticate(session_params[:password]) then
            session[:user_id] = @user.id
            # session[:login_attempts] = 0
            redirect_to mazes_path
        # elsif session[:login_attempts] >= limit
        #     login_limit_reached
        else
            flash[:error] = "Invalid login attempt" #, attempt #{session[:login_attempts]} of 3"
            redirect_to login_path
        end
    end

    def destroy
        session.delete :user_id
        redirect_to root_path
    end

    private

    # def limit
    #     3
    # end
    
    def session_params
        params.require(:user).permit(:name, :password)
    end

    def login_limit_reached
        flash[:error] = "Login attempt limit reached, do you want to create a different user?"
        redirect_to login_path
    end

end