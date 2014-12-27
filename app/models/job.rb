class Job < ActiveRecord::Base
  scope :visible, ->{ where("jobs.visible_until <= ?", Time.now) }

  before_create :generate_token

private

  def generate_token
    self.token ||= SecureRandom.hex(100)
  end
end
