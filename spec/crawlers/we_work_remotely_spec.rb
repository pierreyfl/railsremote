require 'spec_helper'

describe WeWorkRemotely do
  class FixtureFetch
    def initialize(url)
    end

    def html
      File.open(File.join(Rails.root, 'spec', 'support', 'fixtures', 'we_work_remotely.html'), 'r').read
    end
  end

  describe '#to_h' do
    it 'extracts relevant fields' do
      hash = described_class.new('https://weworkremotely.com/jobs/1171', FixtureFetch).to_h
      expect(hash['title']).to eq("")
      expect(hash['company_name']).to eq("")
      expect(hash['company_url']).to eq("")
      expect(hash['description']).to eq("")
      expect(hash['how_to_apply']).to eq("")
    end
  end
end
