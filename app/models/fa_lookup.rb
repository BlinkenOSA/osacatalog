class FaLookup
  include Blacklight::Configurable
  include Blacklight::SearchHelper

  attr_reader :id

  def initialize(reference_code, level)
    @id = get_fa_by_refcode(reference_code, level)
  end

  protected

  def get_fa_by_refcode(reference_code, level)
    solr_response =  Blacklight.default_index.connection.select(
      :params => {
        :q => "reference_code:\"" + reference_code + "\" AND description_level_facet:" + level,
        :fl => "id"
      }
    )

    numFound = solr_response["response"]["numFound"]

    if numFound == 1
      id = solr_response["response"]["docs"][0]["id"]
      return id
    else
      return false
    end
  end

end
