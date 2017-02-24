class FalistController < ApplicationController

  def index
    docs = ''
    container = ''

    fa_list = FaStructureDetailed.new(params[:id]).faList_detailed

    fa_list.each_with_index do |doc, index|
      j = JSON.parse(Base64.decode64(doc[:item_json_e]))

      if doc[:container_number_e] != container
        if index > 0
          docs << '</tbody>'
          docs << '</table>'
        end
        docs << '<div class="container_number"><span>' + j['containerType'] + ' #' + doc[:container_number_e].to_s + '</span></div>'

        docs << '<table>'
        docs << '<tbody>'
        container = doc[:container_number_e]
      end

      docs << '<tr>'

      docs << '<td class="sequence_number">'
      docs << j['sequenceNumber'].to_i.to_s
      docs << '</td>'

      docs << '<td>'

      # TEXTUAL
      if j['primaryType'] == 'Textual'
        docs << '<strong>' + j['title'] + '</strong>'

        if j['dateFrom']
          docs << '., ' + j['dateFrom']
        end

        if j['dateTo'] && j['dateFrom'] != j['dateTo']
          docs << ' - ' + j['dateTo']
        end

        docs << '<br/>'

        if j['note']
          docs << '<em>[' + j['note'] + ']</em>'
        end

      # AV
      elsif j['primaryType'] == 'Moving Image'
        docs << '<strong>' + j['title'] + '</strong>'

        if j['titleOriginal']
          docs << '<strong> / ' + j['titleOriginal'] + '</strong>'
        end

        if j['form_genre']
          docs << ' (' + j['form_genre'] + ')'
        end

        docs << '<br/>'

        if j['contentsSummary']
          docs << j['contentsSummary']
          docs << '<br/>'
        end

        if j['language']
          docs << j['language'].join(', ')
          docs << ' language, '
        end

        unless j['dates'].empty?
          j['dates'].each do |date|
            docs << date['dateType'] + ': '
            docs << date['date']
          end
          docs << ', '
        end

        if j['duration']
          docs << 'Duration: ' + j['duration']
        end

      end

      docs << '</td>'
      docs << '</tr>'
    end

    render html: docs.html_safe
  end

end
