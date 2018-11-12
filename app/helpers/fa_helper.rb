module FaHelper
  def get_fa_title(document)
    (document['title']).html_safe
  end

  def get_fa_title_date(document)
    date = document['date_created']
    if date
      date = '[' + date + ']'
    end
    return date
  end

  def render_fa_date_field(document)
    fa_html = ''
    fa = ActiveSupport::JSON.decode(document['item_json'])['item_json_eng']

    if fa['dateFrom']
      fa_html = '<dt>' + 'Date(s)' + '</dt>'
      fa_html << '<dd>'
      fa_html << fa['dateFrom']
    end

    if fa['dateTo']
      fa_html << ' - '
      fa_html << fa['dateTo']
    end

    fa_html << '</dd>'
    fa_html.html_safe
  end

  def render_fa_list(series_id)
    FaStructure.new(series_id).faList
  end

  def render_fa_title(item_json, lang='en')
    j = JSON.parse(Base64.decode64(item_json))
    if lang == 'en'
      title = '<strong>' + j['title'] + '</strong>'
    else
      title = '<strong>' + j['titleOriginal'] + '</strong>'
    end
    title.html_safe
  end

  def render_fa_call_number(item_json)
    j = JSON.parse(Base64.decode64(item_json))['item_json_eng']
    call_number = j['seriesReferenceCode'] + ':' +
        j['containerNumber'].to_i.to_s + '/' + j['sequenceNumber'].to_i.to_s
    call_number.html_safe
  end

  def render_fa_legacy_id(item_json)
    legacy_id = ""
    j = JSON.parse(Base64.decode64(item_json))['item_json_eng']
    if j.key?('legacyID')
      legacy_id << j['legacyID']
    end
    legacy_id.html_safe
  end

  def render_fa_description(item_json)
    item = ''
    j_2nd = {}

    j = JSON.parse(Base64.decode64(item_json))
    if j.has_key?('item_json_2nd')
      j_2nd = j['item_json_2nd']
    end
    j = j['item_json_eng']

    # TEXTUAL
    if j['primaryType'] == 'Textual'
      item << '<div class="row">'
      if j_2nd.has_key?('contentsSummary')
        item << '<div class="col-xs-6">'
        item << '<strong>' + j['title'] + '</strong>'
        if j['dateCreated']
          item << ', ' + j['dateCreated']
        end
        item << '</div>'
        if j['titleOriginal']
          item << '<div class="col-xs-6">'
          item << '<strong>' + j['titleOriginal'] + '</strong>'
          if j['dateCreated']
            item << ', ' + j['dateCreated']
          end
          item << '</div>'
        end
      else
        if j['titleOriginal']
          item << '<div class="col-xs-12">'
          item << '<strong>' + j['title'] + ' / ' + j['titleOriginal'] + '</strong>'
          if j['dateCreated']
            item << ', ' + j['dateCreated']
          end
          item << '</div>'
        else
          item << '<div class="col-xs-12">'
          item << '<strong>' + j['title'] + '</strong>'
          if j['dateCreated']
            item << ', ' + j['dateCreated']
          end
          item << '</div>'
        end
      end
      item << '</div>'

      item << '<div class="row">'
      if j['contentsSummary'] || j_2nd.has_key?('contentsSummary')
        if j_2nd.has_key?('contentsSummary') && j['contentsSummary']
          item << '<div class="col-xs-6 textual_description">'
          item << j['contentsSummary']
          item << '</div>'
          item << '<div class="col-xs-6 textual_description">'
          item << j_2nd['contentsSummary']
          item << '</div>'
        elsif j['contentsSummary']
          item << '<div class="col-xs-12 textual_description">'
          item << j['contentsSummary']
          item << '</div>'
        else
          item << '<div class="col-xs-12 textual_description">'
          item << j_2nd['contentsSummary']
          item << '</div>'
        end
      end

      if j_2nd.has_key?('contentsSummary')
        item << '<div class="col-xs-6">'
        if j['note']
          item << '<em>[' + j['note'] + ']</em>'
        end
        item << '</div>'
        item << '<div class="col-xs-6">'
        if j_2nd['note']
          item << '<em>[' + j_2nd['note'] + ']</em>'
        end
        item << '</div>'
      else
        item << '<div class="col-xs-12">'
        if j['note']
          item << '<em>[' + j['note'] + ']</em>'
        end
        item << '</div>'
      end
      item << '</div>'


    # ELECTRONIC RECORDS
    elsif j['primaryType'] == 'Electronic Record'
      item << '<strong>' + j['title'] + '</strong>'
      if j['dateCreated']
        item << ', ' + j['dateCreated']
      end
      item << '<br/>'
      if j['note']
        item << '<em>[' + j['note'] + ']</em>'
        item << '<br/>'
      end

    # MOVING IMAGE
    elsif j['primaryType'] == 'Moving Image'

      item << '<div class="row">'
      if j_2nd.has_key?('contentsSummary')
        item << '<div class="col-xs-6">'
        item << '<strong>' + j['title'] + '</strong>'
        item << '</div>'
        if j['titleOriginal']
          item << '<div class="col-xs-6">'
          item << '<strong>' + j['titleOriginal'] + '</strong>'
          item << '</div>'
        end

      else
        if j['titleOriginal']
          item << '<div class="col-xs-12">'
          item << '<strong>' + j['title'] + ' / ' + j['titleOriginal'] + '</strong>'
          item << '</div>'
        else
          item << '<div class="col-xs-12">'
          item << '<strong>' + j['title'] + '</strong>'
          item << '</div>'
        end
      end
      item << '</div>'

      if j['contentsSummary'] || j_2nd.has_key?('contentsSummary')
        item << '<div class="row table_contents_summary">'
        if j_2nd.has_key?('contentsSummary') && j['contentsSummary']
          item << '<div class="col-xs-6">' + j['contentsSummary'] + '</div>'
          item << '<div class="col-xs-6">' + j_2nd['contentsSummary'] + '</div>'
        elsif j['contentsSummary']
          item << '<div class="col-xs-12">' + j['contentsSummary'] + '</div>'
        else
          item << '<div class="col-xs-12">' + j_2nd['contentsSummary'] + '</div>'
        end
        item << '</div>'
      end

      item << '<div class="table_technical_data">'

      if j['form_genre']
        if j['form_genre'].instance_of? Array
          item << j['form_genre'].join(', ') + ', '
        elsif j['form_genre'].instance_of? String
          item << j['form_genre'] + ', '
        end
      end

      if j['language']
        item << j['language'].join(', ')
        item << ' language, '
      end
      # item << '<br/>'

      unless j['dates'].empty?
        j['dates'].each do |date|
          item << date['dateType'] + ': '
          item << date['date']
        end
        item << ', '
      end

      if j['duration']
        item << 'Duration: ' + j['duration']
      end
      item << '</div>'

      # Barcode
      if j['digital_version_exists'] and j['digital_version_container_barcode']
        item << '<div class="row table_digital_version">'
        item << '<div class="col-xs-12">'
        item << '<span class="label label-default">Digital version available | '
        item << j['digital_version_container_barcode']
        item << '</span></div>'
        item << '</div>'
        item << '</div>'
      end
    end

    item.html_safe
  end

  def render_fa_series(document)
    series_html = '<dt>'
  end

  def render_fa_field(document, field, label, cap: false, separator: ', ', facet_name: '', lang: 'en')
    fields = []
    fa_html = ''

    if lang != 'en'
      fa = ActiveSupport::JSON.decode(document['item_json'])['item_json_2nd']
      fa_eng = ActiveSupport::JSON.decode(document['item_json'])['item_json_eng']
    else
      fa = ActiveSupport::JSON.decode(document['item_json'])['item_json_eng']
    end

    if fa[field].is_a?(Array)
      fa[field].each_with_index do |field_value, index|
        if cap
          if facet_name != ''
            if lang != 'en'
              fields << link_to(field_value.capitalize, search_catalog_path(('f[' + facet_name + '][]').to_sym => fa_eng[field][index]))
            else
              fields << link_to(field_value.capitalize, search_catalog_path(('f[' + facet_name + '][]').to_sym => field_value))
            end
          else
            fields << field_value.capitalize
          end
        else
          if facet_name != ''
            if lang != 'en'
              fields << link_to(field_value, search_catalog_path(('f[' + facet_name + '][]').to_sym => fa_eng[field][index]))
            else
              fields << link_to(field_value, search_catalog_path(('f[' + facet_name + '][]').to_sym => field_value))
            end
          else
            fields << field_value
          end
        end
      end

      if fields
        fa_html << '<dd>' + fields.join(separator) + '</dd>'
      end

    elsif fa[field].is_a?(String)
      if fa[field] != ''
        if cap
          if facet_name != ''
            if lang != 'en'
              fa_html << '<dd>' + link_to(fa[field].capitalize, search_catalog_path(('f[' + facet_name + '][]').to_sym => fa_eng[field])) + '</dd>'
            else
              fa_html << '<dd>' + link_to(fa[field].capitalize, search_catalog_path(('f[' + facet_name + '][]').to_sym => fa[field])) + '</dd>'
            end
          else
            fa_html << '<dd>' + fa[field].capitalize + '</dd>'
          end
        else
          fa_html << '<dd>' + fa[field] + '</dd>'
        end
      end
    else
      fa_html = ''
    end

    if fa_html != ''
      fa_html = '<dt>' + label + '</dt>' + fa_html
    end

    fa_html.html_safe
  end

  def render_fa_created(document, lang: 'en')
    created = ''

    fa = ActiveSupport::JSON.decode(document['item_json'])['item_json_eng']

    if fa.key?('placeOfCreation')
      created << fa['placeOfCreation'].join(', ')
      created << ', '
    end

    if fa['dateCreated']
      created << fa['dateCreated']
    end

    if created
      created = '<dt>Created</dt><dd>' + created + '</dd>'
    end

    created.html_safe
  end

  def render_fa_associated_names(document, lang: 'en')
    associated_names_html = ''

    if lang != 'en'
      fa = ActiveSupport::JSON.decode(document['item_json'])['item_json_2nd']
      fa_eng = ActiveSupport::JSON.decode(document['item_json'])['item_json_eng']
    else
      fa = ActiveSupport::JSON.decode(document['item_json'])['item_json_eng']
    end

    if fa['associatedPersonal'] || fa['associatedCorporation']
      associated_names_html << '<dt>Associated Names</dt>'

      if fa['associatedCorporation']
        fa['associatedPersonal'].each_with_index do |ap, index|
          associated_names_html << '<dd>'
          if lang != 'en'
            associated_names_html << link_to(ap['name'], search_catalog_path(('f[added_person_facet][]').to_sym => fa_eng['associatedPersonal'][index]['name']))
          else
            associated_names_html << link_to(ap['name'], search_catalog_path(('f[added_person_facet][]').to_sym => ap['name']))
          end

          if ap['role']
            associated_names_html << ' '
            associated_names_html << '('
            associated_names_html << ap['role']
            associated_names_html << ')'
          end
          associated_names_html << ' '
          associated_names_html << '</dd>'
        end
      end

      if fa['associatedCorporation']
        fa['associatedCorporation'].each_with_index do |ac, index|
          associated_names_html << '<dd>'
          if lang != 'en'
            associated_names_html << link_to(ac['name'], search_catalog_path(('f[added_corporation_facet][]').to_sym => fa_eng['associatedCorporation'][index]['name']))
          else
            associated_names_html << link_to(ac['name'], search_catalog_path(('f[added_corporation_facet][]').to_sym => ac['name']))
          end
          if ac['role']
            associated_names_html << ' '
            associated_names_html << '('
            associated_names_html << ac['role']
            associated_names_html << ')'
          end
          associated_names_html << ' '
          associated_names_html << '</dd>'
        end
      end

    end

    associated_names_html.html_safe
  end

  def render_fa_associated_places(document, lang: 'en')
    associated_places_html = ''

    if lang != 'en'
      fa = ActiveSupport::JSON.decode(document['item_json'])['item_json_2nd']
      fa_eng = ActiveSupport::JSON.decode(document['item_json'])['item_json_eng']
    else
      fa = ActiveSupport::JSON.decode(document['item_json'])['item_json_eng']
    end

    if fa['associatedPlace']
      associated_places_html << '<dt>Associated Places</dt>'
      fa['associatedPlace'].each_with_index do |ap, index|
        associated_places_html << '<dd>'
        if lang != 'en'
          associated_places_html << link_to(ap, search_catalog_path(('f[added_geo_facet][]').to_sym => fa_eng['associatedPlace'][index]))
        else
          associated_places_html << link_to(ap, search_catalog_path(('f[added_geo_facet][]').to_sym => ap))
        end
        associated_places_html << '</dd>'
      end
    end

    if fa['associatedCountry']
      fa['associatedCountry'].each_with_index do |ac, index|
        associated_places_html << '<dd>'
        if lang != 'en'
          associated_places_html << link_to(ac, search_catalog_path(('f[added_geo_facet][]').to_sym => fa_eng['associatedCountry'][index]))
        else
          associated_places_html << link_to(ac, search_catalog_path(('f[added_geo_facet][]').to_sym => ac))
        end
        associated_places_html << '</dd>'
      end
    end
    associated_places_html.html_safe
  end

  def render_fa_creator(document, lang: 'en')
    creators_html = ''

    if lang != 'en'
      fa = ActiveSupport::JSON.decode(document['item_json'])['item_json_2nd']
      fa_eng = ActiveSupport::JSON.decode(document['item_json'])['item_json_eng']
    else
      fa = ActiveSupport::JSON.decode(document['item_json'])['item_json_eng']
    end

    if fa['creatorPersonal'] || fa['creatorCorporation']
      role = ""
      creators_html << '<dt>Creators</dt>'

      if fa.key?('creatorPersonal')
        creators_html << '<dd>'
        fa['creatorPersonal'].each_with_index do |cp, index|
          if lang != 'en'
            creators_html << link_to(cp['name'], search_catalog_path(('f[creator_facet][]').to_sym => fa_eng['creatorPersonal'][index]['name']))
          else
            creators_html << link_to(cp['name'], search_catalog_path(('f[creator_facet][]').to_sym => cp['name']))
          end

          if index == fa['creatorPersonal'].length - 1
            if cp['role']
              creators_html << ' ('
              creators_html << cp['role']
              creators_html << ')'
            end
          else
            creators_html << '; '
          end

        end
        creators_html << '</dd>'
      end

      if fa.key?('creatorCorporation')
        creators_html << '<dd>'
        fa['creatorCorporation'].each_with_index do |cc, index|
          if lang != 'en'
            creators_html << link_to(cc['name'], search_catalog_path(('f[creator_facet][]').to_sym => fa_eng['creatorCorporation'][index]['name']))
          else
            creators_html << link_to(cc['name'], search_catalog_path(('f[creator_facet][]').to_sym => cc['name']))
          end
        end
        creators_html << '</dd>'
      end
    end

    creators_html.html_safe
  end

  def render_fa_moving_image_dates(document)
    dates_html = ''
    fa = ActiveSupport::JSON.decode(document['item_json'])['item_json_eng']

    if fa.has_key?('dates')
      fa['dates'].each do |date|
        dates_html << '<dt>' + date['dateType'] + '</dt>'
        dates_html << '<dd>' + date['date'] + '</dd>'
      end
    end

    dates_html.html_safe
  end

  def render_fa_moving_image_contents_summary(document)
    fa_html = ''
    fa = ActiveSupport::JSON.decode(document['item_json'])

    fa_eng = fa['item_json_eng']
    if fa.has_key?('item_json_2nd')
      fa_2nd = fa['item_json_2nd']
    end

    if fa_eng['contentsSummary']
      fa_html << '<dt>' + 'Contents Summary' + '</dt>'
      fa_html << '<dd>'

      if fa_2nd
        fa_html << '<div class="col-xs-6 moving-image-summary">'
        fa_html << fa_eng['contentsSummary']
        fa_html << '</div>'
        fa_html << '<div class="col-xs-6 moving-image-summary">'
        fa_html << fa_2nd['contentsSummary']
        fa_html << '</div>'
      else
        fa_html << fa_eng['contentsSummary']
      end

      fa_html << '</dd>'
    end

    fa_html.html_safe
  end

  def collect_fa_languages(document)
    langauges = ['en']
    fa = ActiveSupport::JSON.decode(document['item_json'])
    if fa.key?('item_json_2nd')
      if fa['item_json_2nd'].length > 3
        langauges.push(fa['item_json_2nd']['metadataLanguage'])
      end
    end

    return langauges
  end
end
