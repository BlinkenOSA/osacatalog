class FalookupController < ApplicationController
  include FalookupHelper

  def lookup
    id = fa_reverse_lookup(params[:lookup])
    if id
      redirect_to catalog_path(id)
    else
      not_found
    end
  end

end
