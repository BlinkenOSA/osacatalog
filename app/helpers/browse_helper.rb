module BrowseHelper
  def link_to_callnumber_browse(document)
    link_to(
      document[:call_number].first,
      shelf_nearby_path(
        start: document[:id]
      ),
      class: "btn btn-sm btn-default collapsed",
      id: "callnumber-browse",
      "aria-labelledby" => "callnumber-browse",
       data: { behavior: "embed-browse",
               start: document[:id],
               embed_viewport: "#callnumber",
               url: shelf_nearby_path(
                 start: document[:id],
                 view: 'gallery'
               )
             }
    )
  end
end
