module MetaHelper

  def render_archival_meta_value(document, field)
    isad = ActiveSupport::JSON.decode(document["isad_json"])
    return isad[field]
  end
end
