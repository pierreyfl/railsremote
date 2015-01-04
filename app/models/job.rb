class Job < ActiveRecord::Base
  TYPES = {
    "--Select Job Type--" => "Unspecified",
    "Long Term" => "Long Term",
    "Project" => "Project"
  }.freeze

  scope :visible, ->{ where("jobs.visible_until >= ?", Time.now).where(published: true) }
  scope :newest_first, ->{ order("jobs.created_at DESC") }

  before_create :generate_token

  def expired?
    visible_until && visible_until < Time.now
  end

  def full_title
    "#{title} at #{company_name}"
  end

  def next_visible
    @next_visible ||= self.class.visible.order("id ASC").where("id > ?", id).first
  end

  def prev_visible
    @prev_visible ||= self.class.visible.order("id DESC").where("id < ?", id).first
  end

  def to_param
    "#{id}-remote-#{full_title.parameterize}"
  end

  def type_specified?
    job_type.present? && job_type != "Unspecified"
  end

private

  def generate_token
    self.token ||= SecureRandom.hex(100)
  end
end
