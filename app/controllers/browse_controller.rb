class BrowseController < ApplicationController
  layout 'osacatalog'

  def index
  end

  def fondslist
  end

  def collections
    if params[:theme]
      theme = params[:theme]
    else
      theme = "All"
    end

    @collectionslist = CollectionsStructure.new(theme).collectionslist
    render json: @collectionslist
  end

  def authors
    @creators = BrowseList.new('author_browse').browselist
    render creators: @creators
  end

  def directors
    @directors = BrowseList.new('director_browse').browselist
    render directors: @directors
  end

  def languages
    @languages = BrowseList.new('language_facet').browselist
    render directors: @languages
  end

  def library_collections
    @library_collections = BrowseList.new('library_collection', 'browselist_all').browselist
    render library_collections: @library_collections
  end

  def digital_collections
    @digital_collections = BrowseList.new('digital_collection', 'browselist_all').browselist
    render digital_collections: @digital_collections
  end

end
