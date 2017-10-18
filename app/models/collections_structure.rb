class CollectionsStructure
  include Blacklight::Configurable
  include Blacklight::SearchHelper
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  attr_reader :collectionslist

  def initialize(theme)
      @collectionslist = get_all(theme)
  end

  protected

  def get_all(theme)
    collections = []
    prev_level = ""
    fonds_id = ""
    subfonds_id = ""

    if theme == 'All'
      q = "archival_level_facet:\"Archival Unit\""
    else
      q = "archival_level_facet:\"Archival Unit\" AND archival_unit_theme_facet:\"%s\"" % theme
    end
    
    solr_response =  Blacklight.default_index.connection.export(
      :params => {
        :q => q,
        :fl => "id_e,reference_code_e,title_e,title_original_e,description_level_e",
        :sort => "fonds_esort asc,subfonds_esort asc,series_esort asc",
      }
    )

    documents = solr_response[:response][:docs]
    documents.each do |doc|
      title_original_e = ""
      if doc[:title_original_e].length > 0
        title_original_e = ' <span class="unit-hu">(' + doc[:title_original_e].force_encoding("UTF-8") + ')</span>'
      end
      collection = {}

      if doc[:description_level_e] == "Fonds"
        collection["id"] = doc[:id_e]
        collection["parent"] = "#"
        collection["text"] = doc[:reference_code_e].force_encoding("UTF-8") + ' ' + doc[:title_e].force_encoding("UTF-8") + title_original_e
        collection["icon"] = "fa fa-archive"
        prev_level = "Fonds"
        fonds_id = doc[:id_e]
      end

      if doc[:description_level_e] == "Subfonds"
        collection["id"] = doc[:id_e]
        collection["parent"] = fonds_id
        collection["text"] = doc[:reference_code_e].force_encoding("UTF-8") + ' ' + doc[:title_e].force_encoding("UTF-8") + title_original_e
        collection["icon"] = "fa fa-folder-o"
        prev_level = "Subfonds"
        subfonds_id = doc[:id_e]
      end

      if doc[:description_level_e] == "Series"
        collection["id"] = doc[:id_e]
        collection["text"] = doc[:reference_code_e].force_encoding("UTF-8") + ' ' + doc[:title_e].force_encoding("UTF-8") + title_original_e
        collection["icon"] = "fa fa-folder-o"

        if prev_level == "Fonds"
          collection["parent"] = fonds_id
        elsif prev_level == "Subfonds"
          collection["parent"] = subfonds_id
        else
          collection["parent"] = subfonds_id
        end
      end

      if !collection.empty?
        collections << collection
      end
    end

    return JSON.generate(collections)
  end
end
