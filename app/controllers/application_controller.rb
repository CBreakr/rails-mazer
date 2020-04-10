class ApplicationController < ActionController::Base
    def welcome 
        if !current_user then
            redirect_to login_path
        end
        @val = 1
    end

    def current_user
        if is_logged_in then
            User.find(session[:user_id])
        else
            nil
        end
    end
    
    def is_logged_in
        session.has_key?(:user_id) && session[:user_id].present?
    end

    def check_user
        @user = current_user
        if !@user then
            redirect_to login_path
        end
    end
end
