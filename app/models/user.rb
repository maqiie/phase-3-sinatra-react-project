class User < ActiveRecord::Base
    has_many :Projects
end