class FaStructure
  include Blacklight::Configurable
  include Blacklight::SearchHelper
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  attr_reader :faList

  def initialize(series_id)
    @faList = get_fa_structure(series_id)
  end

  protected

  def get_fa_structure(series_id)
    solr_response =  Blacklight.default_index.connection.export(
      :params => {
        :q => "series_id:" + series_id,
        :fl => "id_e,title_e,item_json_e,description_level_e,container_number_e,container_type_e,sequence_number_e",
        :sort => "container_number_esort asc, sequence_number_esort asc, container_type_esort asc",
        :wt => "json"
      }
    )
    documents = solr_response[:response][:docs]
    return documents
  end
end
