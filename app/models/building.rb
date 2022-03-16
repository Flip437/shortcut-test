class Building < ApplicationRecord
  extend Import
  include BacklogSave
  has_many :backlogs, as: :backlogable, dependent: :destroy
  after_save :backlog_save
end
