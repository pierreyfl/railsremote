module ApplicationHelper
  def md(text)
    @markdown ||= Redcarpet::Markdown.new(HTMLwithMaxH3,
      autolink: true, no_intra_emphasis: true,
      filter_html: true, no_styles: true,
      link_attributes: { target: '_blank' }
    )
    @markdown.render(text).html_safe
  end
end

class HTMLwithMaxH3 < Redcarpet::Render::HTML
  def header(text, header_level)
    level = [3, header_level.to_i].max
    "<h#{level}>#{text}</h#{level}>"
  end
end
