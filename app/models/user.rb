class User < ApplicationRecord
    has_secure_password

    has_many :journeys
    has_many :mazes, through: :journies

    validates :name, uniqueness: true
end
