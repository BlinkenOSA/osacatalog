require "base64"
require "json"

class FaStructureDetailed
  include Blacklight::Configurable
  include Blacklight::SearchHelper
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  attr_reader :faList_detailed

  def initialize(series_id)
    @faList_detailed = get_fa_structure(series_id)
  end

  protected

  def get_fa_structure(series_id)
    docs = ""
    container = ""

    solr_response =  Blacklight.default_index.connection.export(
      :params => {
        :q => "series_id:" + series_id,
        :fl => "id_e,item_json_e,container_number_e,sequence_number_e",
        :sort => "container_number_esort asc, sequence_number_esort asc",
        :wt => "json"
      }
    )
    documents = solr_response[:response][:docs]

    return documents
  end
end
