class WeWorkRemotely
  def initialize(url, fetcher_class = Fetch)
    @url = url
    @fetcher_class = fetcher_class
  end

  def to_h
    {
      company_name: doc.css(".listing-header-container .company").first.text,
      title: doc.css(".listing-header-container h1").first.text,
      company_url: doc.css(".listing-header-container h2 a").first.text,
      how_to_apply: doc.css(".apply p").first.text,
      description: doc.css(".job .listing-container").first.text
    }
  end

private

  def doc
    @doc ||= begin
      fetcher = @fetcher_class.new @url
      Nokogiri.parse fetcher_class.new(@url).html
    end
  end
end

class Fetch
  def initialize(url)
    @url = url
  end

  def html
    RestClient.get(url)
  end
end
