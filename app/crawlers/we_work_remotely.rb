class WeWorkRemotely
  URL = "https://weworkremotely.com/jobs/search?term=rails"
  def self.call
    doc = Fetch.new(URL).doc
    edit_links = doc.css("article li a").map do |a|
      path = a.attr('href')
      puts "-> #{path}"
      attrs = WeWorkRemotely.new("https://weworkremotely.com#{path}").to_h
      unless Job.where(attrs.slice(:title, :company_name)).any?
        job = Job.new attrs
        if job.save
          puts "\t-> √. http://www.railsremote.com/jobs/#{job.id}/edit?token=#{job.token}"
        else
          puts "\t-> X. #{job.errors.full_messages}"
        end
      end
    end
  end

  def initialize(url, fetcher_class: Fetch)
    @url = url
    @fetcher_class = fetcher_class
  end

  def to_h
    {
      company_name: doc.css(".listing-header-container .company").first.try(:text),
      title: doc.css(".listing-header-container h1").first.try(:text),
      company_url: doc.css(".listing-header-container h2 a").first.try(:text),
      how_to_apply: doc.css(".apply p").first.try(:text),
      description: ReverseMarkdown.convert(doc.css(".job .listing-container").first.try(:to_html)).to_s.strip
    }
  end

private

  def doc
    @doc ||= begin
      fetcher = @fetcher_class.new @url
      fetcher.doc
    end
  end
end
