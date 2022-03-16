class Backlog < ApplicationRecord
  belongs_to :backlogable, polymorphic: true #we make it polymorphic so we can "plug" it to any model we want and track that model
end
