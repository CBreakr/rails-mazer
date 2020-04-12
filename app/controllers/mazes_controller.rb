class MazesController < ApplicationController
    before_action :check_user
    before_action :get_maze, only: [:show, :update, :destroy, :check_solve, :check_step, :reset]

    def index
        @mazes = Maze.all.filter do |maze|
            !maze.check_mode || maze.creator == @user
        end
    end

    def show
        @maze_processor = MazeProcessor.create_from_model(@maze)
        @maze_processor.hide_current_node
        @solved = false

        if @maze_processor.end_node.is_seen then
            @solved = true
        end
    end

    def create
        length = maze_params[:length].to_i
        width = maze_params[:width].to_i
        if length.is_a?(Integer) && width.is_a?(Integer) && MazeProcessor.within_size_limits(length, width) then
            maze_processor = MazeProcessor.create_random_maze(length, width)
            @maze = Maze.new(maze_processor.create_hash)
            @maze.creator_id = @user.id
            @maze.save
            redirect_to maze_path(@maze)
        else
            # just go back to the index page
            redirect_to mazes_path
        end
    end

    def update
        # we can only update the name
        if maze_params.has_key?(:name) && @maze.creator == @user then
            @maze.update(name: maze_params[:name])
        end
        redirect_to maze_path(@maze)
    end

    def destroy
        if @maze.creator == @user then
            @maze.destroy
        end
        redirect_to mazes_path
    end

    def check_solve
        if @maze.creator == @user then
            @maze.check_mode = true
            @maze.save
        end

        redirect_to maze_path(@maze)
    end

    def check_step
        if @maze.creator == @user then
            @maze_processor = MazeProcessor.create_from_model(@maze)

            if !@maze_processor.end_node.is_seen then
                @maze_processor.next_check_step;
                @maze.update(@maze_processor.create_hash)
            end

            if @maze_processor.end_node.is_seen then
                @solved = true
            end

            @maze_processor.hide_current_node

            render :show
        else
            redrect_to maze_path(@maze)
        end

        
    end

    def reset
        if @maze.creator == @user && @maze.check_mode then
            maze_processor = MazeProcessor.create_from_model(@maze)
            maze_processor.reset
            @maze.check_mode = false
            @maze.update(maze_processor.create_hash)
        end

        redirect_to maze_path(@maze)
    end

    private

    def get_maze
        @maze = Maze.find(params[:id])
    end
    
    def maze_params
        params.require(:maze).permit(:name, :length, :width)
    end
end
