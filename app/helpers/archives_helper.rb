module ArchivesHelper
  def get_archival_title(document)
    title = document["reference_code"] + ' ' + document["title"]
    if document["title_original"]
      title += ' <span class="unit-hu">(' + document["title_original"] + ')</span>'
    end
    title.force_encoding("UTF-8").html_safe
  end

  def get_archival_date(document)
    date = document["creation_date"]
    if date
      date = "[" + date + "]"
    end
    return date
  end

  def collect_au_languages(document)
    langauges = ['en']
    if document.key?("isad_json_hu")
      isad_hu = ActiveSupport::JSON.decode(document["isad_json_hu"])
      if not isad_hu.empty?
        langauges.push('hu')
      end
    end

    return langauges
  end

  def render_fond_list(document)
    FondsStructure.new(document).fondslist
  end

  def render_isad_field(document, field, label, capitalize: false, separator: ", ", subfield: nil, lang: 'en')
    t = []
    isad_html = "<dt>" + label + "</dt>"

    if lang == 'en'
      isad = ActiveSupport::JSON.decode(document["isad_json"])
    else
      isad = ActiveSupport::JSON.decode(document["isad_json_hu"])
    end

    if isad[field].is_a?(Array)
      if subfield

      else
        if capitalize
          isad_html << "<dd>" + isad[field].map!(&:capitalize).join(separator) + "</dd>"
        else
          isad_html << "<dd>" + isad[field].join(separator) + "</dd>"
        end
      end
    elsif isad[field].is_a?(String)
      if capitalize
        isad_html << "<dd>" + isad[field].capitalize + "</dd>"
      else
        isad_html << "<dd>" + isad[field] + "</dd>"
      end
    else
      isad_html = ""
    end
    return isad_html.html_safe
  end

  def render_isad_dates(document, lang='en')
    dates = ""
    isad = ActiveSupport::JSON.decode(document["isad_json"])
    dates << isad["dateFrom"].to_s

    if isad["dateTo"]
      dates << " - "
      dates << isad["dateTo"].to_s
    end

    if dates
      if lang == 'en'
        date_html = "<dt>" + "Date(s)" + "</dt><dd>" + dates + "</dd>"
      else
        date_html = "<dt>" + "Idő(kör)" + "</dt><dd>" + dates + "</dd>"
      end
    end

    return date_html.html_safe
  end

  def render_isad_accruals(document, lang: 'en')
    if lang == 'en'
      accruals = "<dt>Accruals</dt>"
      if document["accruals"]
        accruals << "<dd><p>Expected</p></dd>"
      else
        accruals << "<dd><p>Not expected</p></dd>"
      end
    else
      accruals = "<dt>Jövőbeni gyarapodás</dt>"
      if document["accruals"]
        accruals << "<dd><p>Várható</p></dd>"
      else
        accruals << "<dd><p>Nem várható</p></dd>"
      end
    end

    return accruals.html_safe
  end

  def render_isad_creators(document, lang: 'en')
    creators = []
    creator_html = ""
    isad = ActiveSupport::JSON.decode(document["isad_json"])

    if isad["creator"]
      isad["creator"].each do |creator|
        creators << creator
      end
    end

    if !creators.blank?
      creator_html << "<dd>"
      creators.uniq.each do |cre_unq|
        creator_html << cre_unq + "<br/>"
      end
      creator_html << "</dd>"
    end

    if creator_html != ""
      if lang == 'en'
        creator_html = "<dt>" + "Name of creator(s)" + "</dt>" + creator_html
      else
        creator_html = "<dt>" + "Az iratképző(k) neve" + "</dt>" + creator_html
      end
    end

    return creator_html.html_safe
  end

  def render_related_units(document, field, label, lang: 'en')
    units = []
    units_html = ""

    if lang == 'en'
      isad = ActiveSupport::JSON.decode(document["isad_json"])
    else
      isad = ActiveSupport::JSON.decode(document["isad_json_hu"])
    end

    if field == "relatedUnits"
      tfield = "name"
    else
      tfield = "info"
    end

    if isad[field]
      isad[field].each do |unit|
        if unit["url"] != ""
          units << link_to(unit[tfield], catalog_path(unit["url"]))
        else
          units << unit[tfield]
        end
      end
    end

    if !units.blank?
      units_html << "<dd>" + units.join('<br/>') + "</dd>"
    end

    if units_html != ""
      units_html = "<dt>" + label + "</dt>" + units_html
    end

    return units_html.html_safe
  end
end
