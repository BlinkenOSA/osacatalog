module DrHelper
  def get_dr_title(document)
    title = document["title"]
    title.force_encoding("UTF-8")
  end

  def get_dr_date(document)
    date = document["creation_date"]
    if date
      date = "[" + date + "]"
    end
    return date
  end

  def collect_dr_languages(document)
    DigitalRepositoryRecord.new(document, "en").get_dr_available_languages(document[:id])
  end

  def render_dr_record(document, lang)
    DigitalRepositoryRecord.new(document, lang).display
  end

  def render_dr_viewer(document)
    DigitalRepositoryViewer.new(document).display
  end
end
