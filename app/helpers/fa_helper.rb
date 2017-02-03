module FaHelper
  def get_fa_title(document)
    (document['title']).html_safe
  end

  def get_fa_title_date(document)
    if document['creation_date']
    end
  end

  def render_fa_date_field(document)
    fa_html = ''
    fa = ActiveSupport::JSON.decode(document['item_json'])

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
    j = JSON.parse(Base64.decode64(item_json))
    call_number = j['seriesReferenceCode'] + ':' +
        j['containerNumber'].to_i.to_s + '/' + j['sequenceNumber'].to_i.to_s
    call_number.html_safe
  end

  def render_fa_description(item_json)
    item = ''

    j = JSON.parse(Base64.decode64(item_json))

    # TEXTUAL
    if j['primaryType'] == 'Textual'
      item << '<strong>' + j['title'] + '</strong>'
      if j['titleOriginal']
        item << ' / <strong>' + j['titleOriginal'] + '</strong>'
      end
      if j['dateFrom']
        item << '., ' + j['dateFrom']
      end
      if j['dateTo'] && j['dateFrom'] != j['dateTo']
        item << ' - ' + j['dateTo']
      end
      item << '<br/>'
      if j['note']
        item << '<em>[' + j['note'] + ']</em>'
        item << '<br/>'
      end

    # ELECTRONIC RECORDS
    elsif j['primaryType'] == 'Electronic Record'
      item << '<strong>' + j['title'] + '</strong>'
      if j['dateFrom']
        item << '., ' + j['dateFrom']
      end
      if j['dateTo'] && j['dateFrom'] != j['dateTo']
        item << ' - ' + j['dateTo']
      end
      item << '<br/>'
      if j['note']
        item << '<em>[' + j['note'] + ']</em>'
        item << '<br/>'
      end

    # MOVING IMAGE
    elsif j['primaryType'] == 'Moving Image'

      item << '<div class="row">'
      if j['contentsSummaryOriginal']
        item << '<div class="col-xs-6">'
        item << '<strong>' + j['title'] + '</strong>'
        item << '</div>'
        item << '<div class="col-xs-6">'
        item << '<strong>' + j['titleOriginal'] + '</strong>'
        item << '</div>'
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

      if j['contentsSummary'] || j['contentsSummaryOriginal']
        item << '<div class="row table_contents_summary">'
        if j['contentsSummaryOriginal'] && j['contentsSummary']
          item << '<div class="col-xs-6">' + j['contentsSummary'] + '</div>'
          item << '<div class="col-xs-6">' + j['contentsSummaryOriginal'] + '</div>'
        elsif j['contentsSummary']
          item << '<div class="col-xs-12">' + j['contentsSummary'] + '</div>'
        else
          item << '<div class="col-xs-12">' + j['contentsSummaryOriginal'] + '</div>'
        end
        item << '</div>'
      end

      item << '<div class="table_technical_data">'
      if j['form_genre']
        item << j['form_genre'] + ', '
      end
      if j['language']
        item << j['language'].join(', ')
        item << ' language, '
      end
      # item << '<br/>'

      if !j['dates'].empty?
        j['dates'].each do |date|
          item << date['dateType'] + ': '
          item << date['date']
        end
        item << ', '
      end

      if j['duration']
        item << 'Duration: ' + j['duration']
      end
      item << '</data>'
    end

    item.html_safe
  end

  def render_fa_series(document)
    series_html = '<dt>'
  end

  def render_fa_field(document, field, label, cap = false, separator = ', ', facet_name = '')
    t = []
    fields = []
    fa_html = ''

    fa = ActiveSupport::JSON.decode(document['item_json'])
    if fa[field].is_a?(Array)
      fa[field].each do |field_value|
        if cap
          if facet_name != ''
            fields << link_to(field_value.capitalize, catalog_index_path(('f[' + facet_name + '][]').to_sym => field_value))
          else
            fields << field_value.capitalize
          end
        else
          if facet_name != ''
            fields << link_to(field_value, catalog_index_path(('f[' + facet_name + '][]').to_sym => field_value))
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
            fa_html << '<dd>' + link_to(fa[field].capitalize, catalog_index_path(('f[' + facet_name + '][]').to_sym => fa[field])) + '</dd>'
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

  def render_fa_moving_image_dates(document)
    dates_html = ''
    fa = ActiveSupport::JSON.decode(document['item_json'])

    fa['dates'].each do |date|
      dates_html << '<dt>' + date['dateType'] + '</dt>'
      dates_html << '<dd>' + date['date'] + '</dd>'
    end

    dates_html.html_safe
  end
end
