# -*- encoding : utf-8 -*-
class CatalogController < ApplicationController
  include Blacklight::Marc::Catalog
  include Blacklight::Catalog

  configure_blacklight do |config|
    ## Default parameters to send to solr for all search-like requests. See also SearchBuilder#processed_parameters

    # items to show per page, each number in the array represent another option to choose from.
    config.per_page = [10,20,50,100]

    config.default_solr_params = {
        :qt => 'select',
        :rows => 10
    }

    ## Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SearchHelper#solr_doc_params) or
    ## parameters included in the Blacklight-jetty document requestHandler.
    #
    config.default_document_solr_params = {
        :qt => 'document',
        :fl => '*',
        :rows => 1,
        :q => '{!raw f=id v=$id}'
    }

    # solr field configuration for search results/index views
    config.index.title_field = 'title'
    config.index.display_type_field = 'record_origin'
    config.index.partials = [:index_thumbnail, :index]

    # solr field configuration for document/show views
    config.show.title_field = 'title'
    config.show.display_type_field = 'record_origin'
    config.show.partials = [:show_header, :show_thumbnail, :show]


    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar
    config.add_facet_field 'record_origin_facet', :label => 'Record Origin', collapse: false, partial: 'facet_record_origin'
    # config.add_facet_field 'archival_level_facet', :label => 'Description Group', collapse: false, sort: 'index'
    config.add_facet_field 'primary_type_facet', :label => 'Record Type', collapse: false, partial: 'facet_primary_type'
    config.add_facet_field 'description_level_facet', :label => 'Archival Description Level', collapse: false, sort: 'index', partial: 'facet_description_level'
    config.add_facet_field 'digital_collection', :label => 'Digital Collection', limit: 20

    config.add_facet_field 'date_created_facet', :label => 'Creation Date', :range => {
      :num_segments => 10
    }
    config.add_facet_field 'creator_facet', :label => 'Creator (Author, Director)', limit: true
    config.add_facet_field 'language_facet', :label => 'Language', limit: true
    config.add_facet_field 'genre_facet', :label => 'Form/Genre', limit: true, partial: 'facet_form_genre'

    config.add_facet_field 'added_person_facet', :label => 'Contributor Person', limit: true
    config.add_facet_field 'added_corporation_facet', :label => 'Contributor Corporation', limit: true
    config.add_facet_field 'added_geo_facet', :label => 'Added Geographical Term', limit: true

    config.add_facet_field 'subject_person_facet', :label => 'Subject Person', limit: true
    config.add_facet_field 'subject_corporation_facet', :label => 'Subject Corporation', limit: true
    config.add_facet_field 'subject_geo_facet', :label => 'Subject Geographical Term', limit: true
    config.add_facet_field 'subject_facet', :label => 'Subjects', limit: true

    # BROWSE facets
    config.add_facet_field 'author_browse', :label => 'Author', show: false
    config.add_facet_field 'director_browse', :label => 'Director', show: false
    config.add_facet_field 'library_collection', :label => 'Library Special Collection', show: false

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field 'title', :label => 'Title'
    config.add_index_field 'record_origin', :label => 'Record Origin'
    config.add_index_field 'primary_type', :label => 'Primary Type'
    config.add_index_field 'container_number', :label => 'Container'
    config.add_index_field 'sequence_number', :label => 'Sequence Number'
    config.add_index_field 'date_created', :label=> 'Date Created'
    config.add_index_field 'author', :label=> 'Author'
    config.add_index_field 'director', :label=> 'Director'
    config.add_index_field 'extent', :label=> 'Extent'

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    config.add_show_field 'title', :label => 'Title'
    config.add_show_field 'title_original', :label => 'Original Title'
    config.add_show_field 'alternative_title', :label => 'Alternative Title'

    config.add_show_field 'record_origin', :label => 'Record Origin'
    config.add_show_field 'primary_type', :label => 'Primary Type'
    config.add_show_field 'isbn', :label => 'ISBN'
    config.add_show_field 'reference_code', :label => 'Reference Code'
    config.add_show_field 'description_level', :label => 'Description Level'
    config.add_show_field 'extent', :label => 'Extent'
    config.add_show_field 'subextent', :label => 'Sub-Extent'
    config.add_show_field 'carrier', :label => 'Carrier'

    config.add_show_field 'archival_unit', :label => 'Archival Unit'
    config.add_show_field 'archival_unit_id'
    config.add_show_field 'isad_id'
    config.add_show_field 'container', :label => 'Container'
    config.add_show_field 'sequence_number', :label => 'Sequence Number'

    config.add_show_field 'author', :label => 'Author'
    config.add_show_field 'publisher', :label => 'Publsiher'

    config.add_show_field 'creator', :label => 'Creator'
    config.add_show_field 'isaar_creator', :label => 'Creator (ISAAR)'

    config.add_show_field 'director', :label => 'Director'
    config.add_show_field 'producer', :label => 'Producer'
    config.add_show_field 'copyright', :label => 'Copyright'

    config.add_show_field 'language', :label => 'Language'
    config.add_show_field 'language_statement', :label => 'Langauge Statement'
    config.add_show_field 'genre', :label => 'Genre'

    config.add_show_field 'contents_summary', :label => 'Contents Summary'
    config.add_show_field 'contents_table', :label => 'Contents Table'

    config.add_show_field 'spatial_coverage_country', :label => 'Spatial Coverage - Country'
    config.add_show_field 'spatial_coverage_place', :label => 'Spatial Coverage - Place'

    config.add_show_field 'associated_country', :label => 'Associated Country'
    config.add_show_field 'associated_place', :label => 'Associated Place'
    config.add_show_field 'associated_person', :label => 'Associated Person'
    config.add_show_field 'associated_corporation', :label => 'Associated Corporation'

    config.add_show_field 'subject_country', :label => 'Subject Country'
    config.add_show_field 'subject_place', :label => 'Subject Place'
    config.add_show_field 'subject_person', :label => 'Subject Person'
    config.add_show_field 'subject_corporation', :label => 'Subject Corporation'
    config.add_show_field 'subject', :label => 'Subject'

    config.add_show_field 'source_of_acquisition', :label => 'Source of Acquisition'
    config.add_show_field 'scope_and_content_abstract', :label => 'Scope and Content (Abstract)'
    config.add_show_field 'scope_and_content_narrative', :label => 'Scope and Content (Narrative)'
    config.add_show_field 'appraisal', :label => 'Appraisal'
    config.add_show_field 'accruals', :label => 'Accruals'
    config.add_show_field 'system_of_arrangement', :label => 'System of Arrangement'
    config.add_show_field 'archival_history', :label => 'Archival History'

    config.add_show_field 'rights_access', :label => 'Rights - Access'
    config.add_show_field 'rights_restriction_reason', :label => 'Rights - Restriction Reason'
    config.add_show_field 'rights_reproduction', :label => 'Rights - Reproduction'
    config.add_show_field 'embargo', :label => 'Embargo'

    config.add_show_field 'material_form', :label => 'Material Form'
    config.add_show_field 'physicalDescription', :label => 'Physical Description'
    config.add_show_field 'physicalCondition', :label => 'Physical Condition'

    config.add_show_field 'illustration_statement', :label => 'Illustration Statement'
    config.add_show_field 'sound_statement', :label => 'Sound Statement'
    config.add_show_field 'color_statement', :label => 'Color Statement'
    config.add_show_field 'dimensions', :label => 'Dimensions'

    config.add_show_field 'physical_characteristics', :label => 'Physical Characteristics'
    config.add_show_field 'finding_aids', :label => 'Finding Aids'
    config.add_show_field 'location_of_originals', :label => 'Location of Originals'
    config.add_show_field 'location_of_copies', :label => 'Location of Copies'
    config.add_show_field 'rules_or_convention', :label => 'Rules or Conventions'

    config.add_show_field 'publication_note', :label => 'Publication Note'
    config.add_show_field 'note', :label => 'Note'

    config.add_show_field 'holding', :label => 'Holding'

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.
    config.add_search_field('search_all') do |field|
      field.label = 'All fields'
      field.solr_local_parameters = {
        :qf => '$qf',
        :pf => '$pf',
        :pf2 => '$p2',
        :pf3 => '$pf3'
      }
    end

    config.add_search_field('search_title') do |field|
      field.label = 'Title'
      field.solr_local_parameters = {
        :qf  => '$qf_title',
        :pf  => '$pf_title',
        :pf3 => '$pf3_title',
        :pf2 => '$pf2_title'
      }
    end

    config.add_search_field('search_associated') do |field|
      field.label = 'Associated Entries'
      field.solr_local_parameters = {
        :qf  => '$qf_associated',
        :pf  => '$pf_associated',
        :pf3 => '$pf3_associated',
        :pf2 => '$pf2_associated'
      }
    end

    config.add_search_field('search_subject') do |field|
      field.label = 'Subject Entries'
      field.solr_local_parameters = {
        :qf  => '$qf_subject',
        :pf  => '$pf_subject',
        :pf3 => '$pf3_subject',
        :pf2 => '$pf2_subject'
      }
    end

    config.add_search_field('search_content') do |field|
      field.label = 'Content'
      field.solr_local_parameters = {
        :qf  => '$qf_content',
        :pf  => '$pf_content',
        :pf3 => '$pf3_content',
        :pf2 => '$pf2_content'
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc, fonds_sort asc, subfonds_sort asc, series_sort asc, container_number_sort asc, folder_number_sort asc, sequence_number_sort asc, digital_repository_sort asc, title_sort asc', :label => 'relevance'
    config.add_sort_field 'title_sort asc, score desc, fonds_sort asc, subfonds_sort asc, series_sort asc, container_number_sort asc, sequence_number_sort asc', :label => 'title'
    # config.add_sort_field 'fonds_sort asc, subfonds_sort asc, series_sort asc, container_number_sort asc, sequence_number_sort asc, title_sort asc', :label => 'archival hierarchy'

    # View type group config
    config.view.list.icon_class = "fa-th-list"

    # Gallery settings
    # config.view.gallery.partials = [:index_content]
    # config.view.gallery.icon_class = "fa-th"

    # config.view.brief.partials = [:index_content]
    # config.view.brief.icon_class = "fa-align-justify"

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5
  end

end
