class Task < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { maximum: 50}
  validates :content, presence: true,  length: { maximum: 200}
  enum priority: { 高: 0, 中: 1, 低: 2 }

  scope :search_title, -> (title){where('title LIKE ?', "%#{title}%")}
  scope :search_status, -> (status){where(status: status)}
  scope :search_title_status, -> (title, status){where('title LIKE ?',"%#{title}%").where(status: status)}
end
