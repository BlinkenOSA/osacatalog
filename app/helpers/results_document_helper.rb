module ResultsDocumentHelper

  def get_main_title(document)
    (document['title'] || "").html_safe
  end

  def get_main_title_date(document)
    date = (document['date_created'] || "")
    "[#{date}]" unless date.to_s.empty?
  end

  def archival_date(document)

  end

  def get_author_link(document)
    authors = document[:author]
    wrapper = []

    authors.each do |author|
      wrapper.push(link_to(author, {:controller => "catalog", :action => 'index', "f[creator_facet][]" => author}))
    end

    wrapper.join(", ").html_safe
  end

  def get_book_isbns(document)
    isbn = add_prefix_to_elements( convert_to_array(document['isbn']), 'ISBN' )

    return { 'isbn' => isbn }
  end

  def add_prefix_to_elements(arr, prefix)
    new_array = []

    arr.each do |i|
      new_array.push("#{prefix}#{i}")
    end

    new_array
  end

  def convert_to_array(value = [])
    arr = []

    arr = value if value.kind_of?(Array)
    arr.push(value) if value.kind_of?(String)

    arr
  end

end
