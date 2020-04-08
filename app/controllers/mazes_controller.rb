class MazesController < ApplicationController
    before_action :check_user

    private

    def check_user
        @user = current_user
        if !@user then
            redirect_to login_path
        end
    end
end
