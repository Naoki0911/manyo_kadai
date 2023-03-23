class Label < ApplicationRecord
  has_many :task_label, dependent: :destroy
  has_many :tasks, through: :task_label, source: :task

end
