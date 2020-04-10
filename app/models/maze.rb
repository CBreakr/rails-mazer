class Maze < ApplicationRecord
    has_many :journeys
    has_many :users, through: :journeys

    def creator
        User.find(self.creator_id)
    end

    def current_user_journey(user)
        journeys.find do |j|
            j.user == user
        end
    end
end
