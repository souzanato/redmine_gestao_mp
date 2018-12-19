class RedmineGestaoMpConfig < ActiveRecord::Base
  unloadable

  validates :name, :display_name, :scope, :value, :project_id, presence: true
  validates :name, :display_name, uniqueness: {scope: [:project_id, :scope]}
end
