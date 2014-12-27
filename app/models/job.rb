class Job < ActiveRecord::Base
  scope :visible, ->{ where("jobs.visible_until <= ?", Time.now) }

  before_create :generate_token

  def expired?
    visible_until && visible_until < Time.now
  end

private

  def generate_token
    self.token ||= SecureRandom.hex(100)
  end
end
