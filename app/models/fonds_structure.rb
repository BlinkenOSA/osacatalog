class FondsStructure
  include Blacklight::Configurable
  include Blacklight::SearchHelper
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  attr_reader :fondslist

  def initialize(document)
    @fondslist = get_fond_structure(document)
  end

  protected

  def get_fond_structure(document)
    prev_level = ""
    html = ""
    html << "<ul>"

    fond = document[:fonds]
    solr_response =  Blacklight.default_index.connection.export(
      :params => {
        :q => "fonds:" + fond,
        :fl => "id_e,reference_code_e,title_e,title_original_e,description_level_e",
        :sort => "fonds_esort asc,subfonds_esort asc,series_esort asc"
      }
    )

    documents = solr_response[:response][:docs]
    documents.each do |doc|
      title_original_e = ""
      if doc[:title_original_e].length > 0
        title_original_e = ' <span class="unit-hu">(' + doc[:title_original_e].force_encoding("UTF-8") + ')</span>'
      end
      if doc[:description_level_e] == "Fonds"
        if document[:id] == doc[:id_e]
          html << %Q(<li data-jstree='{"opened": true, "selected": true, "icon":"fa fa-archive"}'>)
        else
          html << %Q(<li data-jstree='{"opened": true, "icon":"fa fa-archive"}'>)
        end
        html << link_to((doc[:reference_code_e].force_encoding("UTF-8") + ' ' + doc[:title_e].force_encoding("UTF-8") + ' ' + title_original_e).html_safe, solr_document_path(doc[:id_e]))
        prev_level = "Fonds"
      end

      if doc[:description_level_e] == "Subfonds"
        if prev_level == "Subfonds"
          html << "</li>"
        elsif prev_level == "Series"
          html << "</li></ul>"
        else
          html << "<ul>"
        end

        if document[:id] == doc[:id_e]
          html << %Q(<li data-jstree='{"opened": true, "selected": true, "icon":"fa fa-folder-o"}'>)
        else
          html << %Q(<li data-jstree='{"opened": false, "icon":"fa fa-folder-o"}'>)
        end

        html << link_to((doc[:reference_code_e].force_encoding("UTF-8") + ' ' + doc[:title_e].force_encoding("UTF-8") + ' ' + title_original_e).html_safe, solr_document_path(doc[:id_e]))
        prev_level = "Subfonds"
      end

      if doc[:description_level_e] == "Series"
        if prev_level == "Series"
          html << "</li>"
        else
          html << "<ul>"
        end

        if document[:id] == doc[:id_e]
          html << %Q(<li data-jstree='{"opened": true, "selected": true, "icon":"fa fa-folder-o"}'>)
        else
          html << %Q(<li data-jstree='{"opened": true, "icon":"fa fa-folder-o"}'>)
        end

        html << link_to((doc[:reference_code_e].force_encoding("UTF-8") + ' ' + doc[:title_e].force_encoding("UTF-8") + ' ' + title_original_e).html_safe, solr_document_path(doc[:id_e]))
        prev_level = "Series"
      end
    end

    html << "</li></ul></li></ul></li></ul>"
    html << "</ul>"
    html.html_safe
  end
end
