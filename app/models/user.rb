class User < ApplicationRecord
    has_secure_password

    has_many :journeys, :dependent => :delete_all
    has_many :mazes, through: :journeys

    validates :name, uniqueness: true

    def journey_for_maze(maze)
        self.journeys.all.find do |j|
            j.maze == maze
        end
    end
end
