module ArchivesHelper
  def get_archival_title(document)
    title = document['reference_code'] + ' ' + document['title']
    if document['title_original']
      title += ' <span class="unit-hu">(' + document['title_original'] + ')</span>'
    end
    title.force_encoding('UTF-8').html_safe
  end

  def get_archival_title_meta(document)
    title = document['reference_code'] + ' ' + document['title']
    if document['title_original']
      title += ' (' + document['title_original'] + ')'
    end
    title.force_encoding('UTF-8')
  end

  def get_archival_date(document)
    date = document['date_created']
    if date
      date = '[' + date + ']'
    end
    return date
  end

  def collect_au_languages(document)
    langauges = ['en']
    if document.key?('isad_json')
      isad = ActiveSupport::JSON.decode(document['isad_json'])
      if isad.key?('isad_json_2nd')
        isad_2nd = ActiveSupport::JSON.decode(isad['isad_json_2nd'])
        if isad_2nd.key?('metadataLanguageCode')
          langauges.push(isad_2nd['metadataLanguageCode'])
        end
      end
    end

    return langauges
  end

  def render_fond_list(document)
    FondsStructure.new(document).fondslist
  end

  def render_group_label(field, lang: 'en')
    label =  I18nHelper.translate(lang, field)
    return label.html_safe
  end

  def render_isad_field(document, field, capitalize: false, separator: ', ', subfield: nil, lang: 'en')
    t = []
    isad_html = '<dt>' + I18nHelper::translate(lang, field) + '</dt>'

    json = ActiveSupport::JSON.decode(document['isad_json'])

    if lang == 'en'
      isad = ActiveSupport::JSON.decode(json['isad_json_eng'])
    else
      isad = ActiveSupport::JSON.decode(json['isad_json_2nd'])
    end

    if isad[field].is_a?(Array)
      if subfield

      else
        if capitalize
          isad_html << '<dd>' + isad[field].map!(&:capitalize).join(separator) + '</dd>'
        else
          isad_html << '<dd>' + isad[field].join(separator) + '</dd>'
        end
      end
    elsif isad[field].is_a?(String)
      if capitalize
        isad_html << '<dd>' + isad[field].capitalize + '</dd>'
      else
        isad_html << '<dd>' + isad[field] + '</dd>'
      end
    else
      isad_html = ''
    end
    return isad_html.html_safe
  end

  def render_isad_dates(document, lang: 'en')
    dates = ''

    json = ActiveSupport::JSON.decode(document['isad_json'])
    isad = ActiveSupport::JSON.decode(json['isad_json_eng'])

    dates << isad['dateFrom'].to_s

    if isad['dateTo']
      if isad['dateTo'] != isad['dateFrom']
        dates << ' - '
        dates << isad['dateTo'].to_s
      end
    end

    if dates
        date_html = '<dt>' + I18nHelper::translate(lang, 'dates') + '</dt><dd>' + dates + '</dd>'
    end

    return date_html.html_safe
  end

  def render_isad_accruals(document, lang: 'en')
    json = ActiveSupport::JSON.decode(document['isad_json'])
    isad = ActiveSupport::JSON.decode(json['isad_json_eng'])

    accruals = '<dt>' + I18nHelper::translate(lang, 'accruals') + '</dt>'
    if isad['accruals']
      accruals << '<dd><p>' + I18nHelper::translate(lang, 'accruals_expected') + '</p></dd>'
    else
      accruals << '<dd><p>' + I18nHelper::translate(lang, 'accruals_not_expected') + '</p></dd>'
    end

    return accruals.html_safe
  end

  def render_isad_creators(document, lang: 'en')
    creators = []
    creator_html = ''
    json = ActiveSupport::JSON.decode(document['isad_json'])
    isad = ActiveSupport::JSON.decode(json['isad_json_eng'])

    if isad['creator']
      isad['creator'].each do |creator|
        creators << creator
      end
    end

    if !creators.blank?
      creator_html << '<dd>'
      creators.uniq.each do |cre_unq|
        creator_html << cre_unq + '<br/>'
      end
      creator_html << '</dd>'
    end

    if creator_html != ''
      creator_html = '<dt>' + I18nHelper::translate(lang, 'creators') + '</dt>' + creator_html
    end

    return creator_html.html_safe
  end

  def render_related_units(document, field, label, lang: 'en')
    units = []
    units_html = ''

    json = ActiveSupport::JSON.decode(document['isad_json'])

    if lang == 'en'
      isad = ActiveSupport::JSON.decode(json['isad_json_eng'])
    else
      isad = ActiveSupport::JSON.decode(json['isad_json_2nd'])
    end

    tfield = 'info'

    if isad[field]
      isad[field].map do |unit|
        if unit['url'] != ''
          units << link_to(unit[tfield], unit['url'])
        else
          units << unit[tfield]
        end
      end
    end

    if !units.blank?
      units_html << '<dd>' + units.join('<br/>') + '</dd>'
    end

    if units_html != ''
      units_html = '<dt>' + I18nHelper::translate(lang, field) + '</dt>' + units_html
    end

    return units_html.html_safe
  end
end
