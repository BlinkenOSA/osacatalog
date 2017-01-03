module IconHelper

  def render_type_icon(values)
    values = Array(values).flatten.compact
    value = values.first
    if Constants::TYPE_ICONS.has_key?(value)
      content_tag(:span, "", class:"type-icon fa fa-#{Constants::TYPE_ICONS[value]}")
    end
  end

  def render_origin_icon(values)
    values = Array(values).flatten.compact
    value = values.first
    if Constants::ORIGIN_ICONS.has_key?(value)
      content_tag(:span, content_tag(:strong, "#{Constants::ORIGIN_ICONS[value]}"), class:"origin-icon")
    end
  end

end
