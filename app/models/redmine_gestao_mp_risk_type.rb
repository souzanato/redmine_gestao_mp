class RedmineGestaoMpRiskType < ActiveRecord::Base
  unloadable
  validates :code, uniqueness: {scope: :title}
  validates :code, :title, presence: true
end
