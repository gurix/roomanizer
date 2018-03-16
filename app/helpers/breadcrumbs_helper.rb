# For more details, see `BreadcrumbsHandler`.

module BreadcrumbsHelper
  def render_breadcrumbs
    @breadcrumbs.map do |breadcrumb|
      content_tag :li do
        title = truncate breadcrumb[:title], length: 30, separator: ' '
        if breadcrumb[:target].blank?
          title
        else
          link_to breadcrumb[:target] do
            title
          end
        end
      end
    end.join.html_safe
  end
end
