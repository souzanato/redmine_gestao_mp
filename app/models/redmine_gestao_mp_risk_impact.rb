class RedmineGestaoMpRiskImpact < ActiveRecord::Base
  unloadable
  validates :code, uniqueness: {scope: :title}
  validates :code, :title, :multiplier, presence: true

  def display_title
  	"#{self.multiplier} - #{self.title}"
  end
end
