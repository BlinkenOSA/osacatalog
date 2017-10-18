class RecordOriginFacets
  include Blacklight::Configurable
  include Blacklight::SearchHelper
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  attr_reader :facetList

  def initialize
    @facetList = get_record_origin_facets
  end

  protected

  def get_record_origin_facets
    html = ""

    solr_response =  Blacklight.default_index.connection.select(
      :params => {
        :q => "*:*",
        :fl => "id",
        :facet => true,
        :"facet.field" => "record_origin_facet",
        :"facet.sort" => "index"
      }
    )

    facets = solr_response["facet_counts"]["facet_fields"]["record_origin_facet"]

    facets.each_with_index do |facet, index|
      if index.even?
        html_params = {
          :"f[record_origin_facet][]" => facet
        }

        html << %Q(<a href="#{search_catalog_path(html_params)}" class="feature-icon">)
        html << %Q(<span class="origin-icon"><strong>)
        html << Constants::ORIGIN_ICONS[facet]
        html << %Q(</strong></span>)
        html << "<h4>" + facet
      else
        html << " (" + facet.to_s + ")</h4>"
        html << %Q(</a>)
      end
    end

    return html.html_safe
  end

end
