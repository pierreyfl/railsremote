class Job < ActiveRecord::Base
  TYPES = {
    "--Select Job Type--" => "Unspecified",
    "Long Term" => "Long Term",
    "Project" => "Project"
  }.freeze

  scope :visible, ->{ where("jobs.visible_until >= ?", Time.now).where(published: true) }

  before_create :generate_token

  def expired?
    visible_until && visible_until < Time.now
  end

private

  def generate_token
    self.token ||= SecureRandom.hex(100)
  end
end
