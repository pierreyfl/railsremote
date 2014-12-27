require 'spec_helper'

describe Job do
  describe "#token" do
    it "is generated on create" do
      job = Job.create!
      expect(job.token).to be_present
    end
  end
end
