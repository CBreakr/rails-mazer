
require "json"

class MazeProcessor
    attr_accessor :name, :maze_array, :length, :width, :start_node, :end_node, :current_node, :iteration, :completed

    def self.minimum_size
        5
    end

    def self.maximum_size
        25
    end

    def hide_current_node
        @current_node.is_current = false
    end

    def self.within_size_limits(length, width)
        if length >= minimum_size && length <= maximum_size && width >= minimum_size && width <= maximum_size then
            return true
        end
        false
    end

    def self.create_from_string(str)
        hash = eval(str)
        create(hash[:name], hash[:length], hash[:width], hash[:iteration], hash[:maze_array_string])
    end
    
    def self.create_from_model(maze_model)
        create(maze_model.name, maze_model.length, maze_model.width, maze_model.iteration, maze_model.maze_array_string)
    end

    def self.create(name, length, width, iteration, maze_array_string)
        maze = MazeProcessor.new
        maze.name = name
        maze.length = length
        maze.width = width
        maze.iteration = iteration

        if !MazeProcessor.within_size_limits(maze.length, maze.width) then
            return nil
        end

        arr = JSON.parse(maze_array_string)

        if arr then
            maze.maze_array = []
            arr.each do |mnh|
                node = MazeNode.create_from_hash(mnh)
                maze.maze_array << node
                maze.start_node = node if node.is_start
                maze.end_node = node if node.is_end
                maze.current_node = node if node.is_current
            end
        end

        if maze.current_node.is_end then
            maze.completed = true
        end

        maze
    end

    def self.create_random_maze(length, width)
        maze = MazeProcessor.new
        maze.length = length
        maze.width = width

        if !MazeProcessor.within_size_limits(length, width) then
            return nil
        end

        start_end_coords = create_start_and_end_coordinates(length, width)

        # byebug 

        count = 0

        # maze.check_start_end_distance &&
        until maze.check_solveable
            count += 1
            maze.maze_array = []
            maze.start_node = nil
            maze.end_node = nil
            length.times do |x|
                width.times do |y|
                    node = MazeNode.create_random(x, y)
                    start_end_node_check(node, start_end_coords, maze)
                    # maze.start_node = node if node.is_start
                    # maze.end_node = node if node.is_end
                    maze.maze_array << node
                end
            end

            # byebug
            # maze.ensure_start_and_end_exist
        end

        # byebug
        maze.iteration = count

        return maze
    end

    def adjacency_list(node)
        # find the nodes within 1 of x & y for input node
        # do this based on the length and width
        # 
        # get the bounds, translate into index 
        # x * length + y * width
        adj_list = []
        adjacent_indexes(node).each {|i| adj_list << maze_array[i] }
        adj_list
    end

    def check_solveable
        if !@start_node || !@end_node then
            return false
        end

        result = false

        queue = [@start_node]

        while queue.length > 0
            current = queue[0]
            if !current.is_visited then
                if current.is_end then
                    result = true
                    reset # cleanup method, not important for algorithm
                    break
                end
                current.is_visited = true
                adj_list = adjacency_list(current) # helper method to get adjacent nodes
                adj_list.each do |node| 
                    queue << node if !node.is_visited && !node.is_barrier
                end
            end

            queue.shift
        end

        return result
    end

    def create_hash
        maze_hash = {}
        maze_hash[:name] = @name
        maze_hash[:length] = @length
        maze_hash[:width] = @width
        maze_hash[:iteration] = @iteration
        
        arr = []

        @maze_array.each do |node|
            arr << node.create_serialized
        end

        maze_hash[:maze_array_string] = JSON.generate(arr)
        maze_hash
    end

    def attempt_move_up
        up_index = index(@current_node.x, @current_node.y-1)
        set_current_node_by_index(up_index)
    end

    def attempt_move_down
        down_index = index(@current_node.x, @current_node.y+1)
        set_current_node_by_index(down_index)
    end

    def attempt_move_right
        right_index = index(@current_node.x+1, @current_node.y)
        set_current_node_by_index(right_index)
    end

    def attempt_move_left
        left_index = index(@current_node.x-1, @current_node.y)
        set_current_node_by_index(left_index)
    end

    ###########################
    ###########################
    ###########################

    private

    def set_current_node_by_index(index)
        if index && !@completed then
            node = @maze_array[index]
            if !node.is_barrier then
                node.is_current = true
                node.is_visited = true
                @current_node.is_current = false
                @current_node = node
                if @current_node.is_end then
                    @completed = true
                end
                return index
            end
        end
        nil
    end

    def adjacent_indexes(node)
        [
            index(node.x-1, node.y), 
            index(node.x, node.y+1),
            index(node.x+1, node.y),
            index(node.x, node.y-1)
        ].compact
    end

    def index(x, y)
        if x >= 0 && x < @length && y >= 0 && y < @width then      
            return x*@width + y
        end
        nil
    end

    def reset
        maze_array.each do |node|
            node.is_visited = false
            node.is_current = false
        end
        start_node.is_current = true
    end

    def self.create_start_and_end_coordinates(length, width)
        coords = [0,0,0,0]
        dist = (length + width)/2
        while start_end_coordinates_too_close(coords, dist)
            coords = [
                rand(0...length),
                rand(0...width),
                rand(0...length),
                rand(0...width)
            ]
        end

        coords
    end

    def self.start_end_coordinates_too_close(coords, dist)
        x_diff = (coords[0] - coords[2]).abs
        y_diff = (coords[1] - coords[3]).abs
        
        return (x_diff + y_diff) <= dist
    end

    def self.start_end_node_check(node, coords, maze)
        if node.x == coords[0] && node.y == coords[1] then
            node.set_as_start
            maze.start_node = node
        elsif node.x == coords[2] && node.y == coords[3] then
            node.set_as_end
            maze.end_node = node
        end
    end
end
