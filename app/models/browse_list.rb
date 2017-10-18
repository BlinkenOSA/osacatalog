class BrowseList
  include Blacklight::Configurable
  include Blacklight::SearchHelper
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  attr_reader :browselist

  def initialize(facet_name, id = "browselist")
    @browselist = get_list(facet_name, id)
  end

  protected

  def get_list(facet_name, id)
    html = ""

    params = "f[" + facet_name + "][]"
    html_params = Hash.new

    solr_response =  Blacklight.default_index.connection.select(
      :params => {
        :q => "*:*",
        :fl => "id",
        :facet => true,
        :"facet.field" => facet_name,
        :"facet.limit" => -1,
        :"facet.sort" => "index"
      }
    )

    print solr_response
    facets = solr_response["facet_counts"]["facet_fields"][facet_name]

    html << '<ul id="' + id + '">'

    facets.each_with_index do |facet, index|
      if index.even?

        html_params[params] = facet

        html << %Q(<li>)
        html << %Q(<a href="#{search_catalog_path(html_params)}">)
        html << facet
      else
        html << " (" + facet.to_s + ")"
        html << %Q(</li>)
      end
    end

    html << %Q(</ul>)
    html.html_safe

  end
end
