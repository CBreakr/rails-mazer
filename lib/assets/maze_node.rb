
class MazeNode
    attr_accessor :x, :y, :is_start, :is_end, :is_visited, :is_barrier, :is_current, :move_number, :is_seen

    # def initialize(x, y, set_random, start_node, end_node)
    def self.create_random(x, y)
        node = MazeNode.new
        node.x = x
        node.y = y
        
        if rand < 0.4 then
            node.is_barrier = true
        end

        node
    end

    def set_as_start
        @is_barrier = false
        @is_start = true
        @is_current = true
    end

    def set_as_end
        @is_barrier = false
        @is_end = true
    end

    def class_name
        cl = ""

        if is_start then
            cl = "start"
        elsif is_end then
            if is_seen then
                cl = "seen"
            end
            cl += "end"
        elsif is_visited then
            cl = "visited"
        elsif is_barrier then
            cl = "barrier"
        elsif is_seen then
            cl = "seen"
        end

        if is_current then
            cl += " current"
        end

        cl
    end

    def create_serialized
        return {
            x: @x, 
            y: @y, 
            is_start: @is_start, 
            is_end: @is_end, 
            is_visited: @is_visited, 
            is_barrier: @is_barrier, 
            is_current: @is_current,
            is_seen: @is_seen,
            move_number: @move_number
        }
    end

    def self.create_from_hash(hash)
        node = MazeNode.new
        node.x = hash["x"]
        node.y = hash["y"]
        node.is_start = hash["is_start"]
        node.is_end = hash["is_end"]
        node.is_visited = hash["is_visited"]
        node.is_barrier = hash["is_barrier"]
        node.is_current = hash["is_current"]
        node.is_seen = hash["is_seen"]
        node.move_number = hash["move_number"]
        node
    end
end