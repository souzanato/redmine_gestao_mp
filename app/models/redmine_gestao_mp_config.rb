class RedmineGestaoMpConfig < ActiveRecord::Base
  unloadable

  validates :name, :display_name, :scope, :value, :project_id, presence: true
  validates :name, uniqueness: {scope: [:project_id, :scope]}
  validates :display_name, uniqueness: {scope: [:project_id, :scope, :name]}

  belongs_to :project
end
