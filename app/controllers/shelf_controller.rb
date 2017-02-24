class ShelfController < ApplicationController
  include Blacklight::Catalog::SearchContext
  include Blacklight::SolrHelper

  include Blacklight::Configurable

  copy_blacklight_config_from(CatalogController)

  def nearby
    if params[:start].present?
      @response, @original_doc = get_solr_response_for_doc_id(params[:start])
      original_doc_id = @original_doc[:id]
      callnum = @original_doc[:call_number_key].downcase
      callnum_rev = @original_doc[:call_number_reversed_key].downcase
      respond_to do |format|
        format.html do
          @document_list = NearbyOnShelf.new(
              'static',
              {:original_doc_id => original_doc_id,
             :call_number_key => callnum,
             :call_number_reversed_key => callnum_rev,
             :before => 10,
             :after => 9}
          ).items.map do |document|
            SolrDocument.new(document[:doc])
          end
          render shelf: @document_list, layout: false
        end
      end
    end
  end

  private

  def _prefixes
    @_prefixes ||= super + ['catalog']
  end
end
