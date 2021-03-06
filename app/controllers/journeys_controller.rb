class JourneysController < ApplicationController
    before_action :check_user
    before_action :get_journey, only: [:show, :move, :destroy]

    def index
        @journeys = @user.journeys
    end

    def show
        if @journey.user == @user then
            @maze_processor = MazeProcessor.create_from_string(@journey.maze_state_string)
        else
            redirect_to journeys_path
        end
    end

    def create
        journey = Journey.new
        journey.maze_id = params[:maze_id]
        journey.user_id = params[:user_id]
        journey.is_finished = false
        journey.maze_state_string = MazeProcessor.create_from_model(journey.maze).create_hash.inspect
        journey.save
        redirect_to journey_path(journey)
    end

    def move
        # this one is more complicated
        maze = @journey.maze
        if !maze then
            redirect_to mazes_path
        else
            @maze_processor = MazeProcessor.create_from_string(@journey.maze_state_string)
            updated = false

            case params[:move]            
            when "UP"
                # byebug
                updated = @maze_processor.attempt_move_up
            when "DOWN"
                # byebug
                updated = @maze_processor.attempt_move_down
            when "LEFT"
                # byebug
                updated = @maze_processor.attempt_move_left
            when "RIGHT"
                # byebug
                updated = @maze_processor.attempt_move_right
            end

            if updated
                @journey.is_finished = @maze_processor.completed
                @journey.maze_state_string = @maze_processor.create_hash.inspect
                @journey.save
            end

            # avoid doing another DB read and object creation
            render :show
        end
    end

    def destroy
        @journey.delete
        redirect_to journeys_path
    end

    private

    def get_journey
        @journey = Journey.find(params[:id])
    end

    # def journey_params
    #     params.require(:journey).permit(:user_id, :maze_id)
    # end
end
