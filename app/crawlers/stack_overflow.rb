class StackOverflow < CrawlBase
  def self.config
    {
      url: "http://careers.stackoverflow.com/jobs?searchTerm=ruby&allowsremote=true&sort=p",
      base_url: "http://careers.stackoverflow.com",
      list_link_selector: "h3.h5 a",
    }.freeze
  end

  def to_h
    {
      company_name: doc.css("a.employer").first.try(:text),
      title: doc.css("a.title.job-link").first.try(:text),
      company_url: doc.css("a.employer").first.attr(:href),
      how_to_apply: how_to_apply,
      description: description,
      timezone_preferences: doc.css(".location").first.try(:text)
    }
  end

private

  def how_to_apply
    url = doc.css(".apply i").first.attr("data-uri")
    "[Apply via this link](#{url})"
  end

  def description
    html = doc.css(".description").map{ |x| x.try(:to_html).to_s}.join("\n\n### About The Company\n\n")
    ReverseMarkdown.convert(html).strip
  end
end
