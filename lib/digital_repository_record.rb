class DigitalRepositoryRecord
  include Blacklight::Configurable
  include Blacklight::SearchHelper
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  attr_reader :display

  def initialize(document, lang)
    id = document['id']
    doc = get_datastream(id, lang)
    doc = include_digital_collection(doc, document['digital_collection'], document['digital_collection_id'])
    doc = include_handle(id, doc)
    @display = include_rights(id, doc)
  end

  def get_dr_available_languages(id)
    languages = []
    repo = Rubydora.connect :url => Constants::FEDORA_URL, :user => 'fedoraAdmin', :password => 'QpwoI1209'
    obj = repo.find(id)
    for datastream in obj.datastreams
      key = datastream[0]
      if key.include? "ITEM-ARC"
        key = key.sub("ITEM-ARC-", "").downcase
        languages.append(key)
      end

      if key.include? "ITEM-LIB"
        key = key.sub("ITEM-LIB-", "").downcase
        languages.append(key)
      end
    end

    return languages.sort_by(&:downcase)
  end

  def get_datastream(id, lang)
    url = Constants::FEDORA_GETFOXML + id
    foxml = Net::HTTP.get(URI.parse(url))

    repo = Rubydora.connect :url => Constants::FEDORA_URL, :user => 'fedoraAdmin', :password => 'QpwoI1209'
    obj = repo.find(id)
    if obj.datastreams.has_key?("ITEM-ARC-" + lang.upcase)
      dskey = "ITEM-ARC-" + lang.upcase
      if lang == 'en'
        template = Nokogiri::XSLT(File.read(Rails.root.join('app/assets/xsl/item-arc.xsl')))
      else
        p = ["ds", "'%s'" % [dskey]]
        template = Nokogiri::XSLT(File.read(Rails.root.join('app/assets/xsl/item-arc-lang.xsl')))
      end

    elsif obj.datastreams.has_key?("ITEM-LIB-" + lang.upcase)
      dskey = "ITEM-LIB-" + lang.upcase
      if lang == 'en'
        template = Nokogiri::XSLT(File.read(Rails.root.join('app/assets/xsl/item-lib.xsl')))
      else
        p = ["ds", "'%s'" % [dskey]]
        template = Nokogiri::XSLT(File.read(Rails.root.join('app/assets/xsl/item-lib-lang.xsl')))
      end
    end

    xml = Nokogiri::XML(foxml) do |config|
      config.noblanks
    end

    if p
      display = template.transform(xml, p).to_s
    else
      display = template.transform(xml).to_s
    end

    sums = []

    summaries = xml.xpath("foxml:digitalObject/foxml:datastream[@ID='" + dskey + "']//osa:contentsSummary",
                          'osa' => 'http://greenfield.osaarchivum.org/ns/item',
                          'foxml' => 'info:fedora/fedora-system:def/foxml#')
    summaries.each do |summary|
      sums.push(summary.text)
    end

    if sums
      display.gsub!("[SUMMARY]", sums.join("<br/>"))
    end

    return display.html_safe
  end

  def include_digital_collection(doc, collection_name, collection_id)
    html = ""
    html << "<dt>Part of</dt>"
    html << "<dd>"
    html << link_to(collection_name, catalog_index_path("f[digital_collection][]".to_sym => collection_name))
    html << ' (<a href="http://www.osaarchivum.org/digital-repository/' + collection_id + '" class="btn-view-collection">view collection record</a>)'
    html << "</dd>"

    doc.gsub!("[COLLECTION]", html)
    return doc
  end

  def include_handle(id, doc)
    hdl = 'http://hdl.handle.net/10891/' + id
    handle = link_to(hdl, hdl)
    doc.gsub!("[HDL]", handle)
    return doc
  end

  def include_rights(id, doc)
    repo = Rubydora.connect :url => Constants::FEDORA_URL, :user => 'fedoraAdmin', :password => 'QpwoI1209'
    obj = repo.find(id)
    if obj.datastreams.has_key?("RIGHTS")
      ds = obj.datastreams["RIGHTS"]
    end

    xml = Nokogiri::XML(ds.read) do |config|
      config.noblanks
    end

    template = Nokogiri::XSLT(File.read(Rails.root.join('app/assets/xsl/rights.xsl')))

    doc.gsub!("[RIGHTS]", template.transform(xml).to_s)
    return doc.html_safe
  end

end
