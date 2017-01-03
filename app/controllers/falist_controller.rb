class FalistController < ApplicationController

  def index
    docs = ""
    container = ""
    close_container = false

    faList = FaStructureDetailed.new(params[:id]).faList_detailed

    faList.each_with_index do |doc, index|
      j = JSON.parse(Base64.decode64(doc[:item_json_e]))

      if doc[:container_number_e] != container
        if index > 0
          docs << %Q(</tbody>)
          docs << %Q(</table>)
        end
        docs << '<div class="container_number"><span>' + j["containerType"] + " #" + doc[:container_number_e].to_s + "</span></div>"

        docs << %Q(<table>)
        docs << %Q(<tbody>)
        container = doc[:container_number_e]
      end

      docs << %Q(<tr>)

      docs << %Q(<td class="sequence_number">)
      docs << j["sequenceNumber"].to_i.to_s
      docs << %Q(</td>)

      docs << %Q(<td>)

      # TEXTUAL
      if j["primaryType"] == "Textual"
        docs << "<strong>" + j["title"] + "</strong>"

        if j["dateFrom"]
          docs << "., " + j["dateFrom"]
        end

        if j["dateTo"] && j["dateFrom"] != j["dateTo"]
          docs << " - " + j["dateTo"]
        end

        docs << "<br/>"

        if j["note"]
          docs << "<em>[" + j["note"] + "]</em>"
        end

      # AV
      elsif j["primaryType"] == "Moving Image"
        docs << "<strong>" + j["title"] + "</strong>"

        if j["titleOriginal"]
          docs << "<strong> / " + j["titleOriginal"] + "</strong>"
        end

        if j["form_genre"]
          docs << " (" + j["form_genre"] + ")"
        end

        docs << "<br/>"

        if j["contentsSummary"]
          docs << j["contentsSummary"]
          docs << "<br/>"
        end

        if j["language"]
          docs << j["language"].join(", ")
          docs << " language, "
        end

        if !j["dates"].empty?
          j["dates"].each do |date|
            docs << date["dateType"] + ": "
            docs << date["date"]
          end
          docs << ", "
        end

        if j["duration"]
          docs << "Duration: " + j["duration"]
        end

      end

      docs << %Q(</td>)
      docs << %Q(</tr>)
    end

    render html: docs.html_safe
  end

end
