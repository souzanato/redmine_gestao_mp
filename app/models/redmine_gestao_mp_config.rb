class RedmineGestaoMpConfig < ActiveRecord::Base
  unloadable

  validates :name, :display_name, :scope, :value, presence: true
  validates :name, :display_name, uniqueness: true
end
