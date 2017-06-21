class DigitalRepositoryViewer
  include Blacklight::Configurable
  include Blacklight::SearchHelper
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  attr_reader :display

  def initialize(document)
    id = document['id']
    xml = get_datastream(id)
    @display = make_viewer(xml)
  end

  def get_datastream(id)
    repo = Rubydora.connect :url => Constants::FEDORA_URL, :user => 'fedoraAdmin', :password => 'QpwoI1209'
    obj = repo.find(id)
    if obj.datastreams.has_key?("METS-STRUCTURE")
      ds = obj.datastreams["METS-STRUCTURE"]
    end

    xml = Nokogiri::XML(ds.read) do |config|
      config.noblanks
    end

    return xml
  end

  def make_viewer(xml)
    html = ""

    types = detect_types(xml)
    types_length = types.length
    types_unique = types.uniq

    if types_unique.length > 1
      # multiFormat
    else
      # singleFormat
      mime = types_unique[0]
      case mime
      when "video/x-flv"
        html << multivideo_multiThumbnail(xml)
      when "audio/mpeg"
        html << multivideo_singleThumbnail(xml)
      when "application/pdf"
        html << multivio_singleThumbnail(xml)
      when "image/jpeg"
        if types_length == 1
          html << multivio_singleThumbnail(xml)
        else
          html << multivio_singleThumbnailImage(xml)
        end
      end
    end

    return html.html_safe
  end

  def detect_types(xml)
    types = []

    elements = xml.xpath("//mets:fileGrp[@USE='low_level']//mets:file")
    elements.each do |element|
      types << element["MIMETYPE"]
    end

    return types
  end

  def multivio_singleThumbnail(xml)
    html = ""
    guid = xml.xpath("//mets:mets").first["OBJID"].gsub("osa:", "")

    low_level_handle = xml.xpath("//mets:fileGrp[@USE='low_level']//mets:fLocat").first["xlink:href"]
    thumbnail_handle = xml.xpath("//mets:fileGrp[@USE='thumbnail']//mets:fLocat").first["xlink:href"]

    html << %Q(<div class="singleThumbnail">)
    html << %Q( <a class="repository-viewer" href="#{low_level_handle}" data-multivio-options="url=#{low_level_handle}" data-multivio-preview="#{thumbnail_handle}"></a>)
    html << %Q(</div>)

    return html
  end

  def multivio_singleThumbnailImage(xml)
    html = ""
    guid = xml.xpath("//mets:mets").first["OBJID"].gsub("osa:", "")

    low_level_xml_link = "http://storage.osaarchivum.org/multivio/" + guid[0,2] + "/" + guid[2,2] + "/" + guid + ".xml"
    thumbnail_handle = xml.xpath("//mets:fileGrp[@USE='thumbnail']//mets:fLocat").first["xlink:href"]

    html << %Q(<div class="singleThumbnail">)
    html << %Q( <a class="repository-viewer" href="#{low_level_xml_link}" data-multivio-options="url=#{low_level_xml_link}" data-multivio-preview="#{thumbnail_handle}"></a>)
    html << %Q(</div>)

    return html
  end

  def multivideo_singleThumbnail(xml)
    html = ""
    guid = xml.xpath("//mets:mets").first["OBJID"].gsub("osa:", "")

    thumbnail = "http://storage.osaarchivum.org/thumbnail/" + guid[0,2] + "/" + guid[2,2] + '/' + guid + '_t_001.jpg'
    low_level_audio = 'http://storage.osaarchivum.org/low/' + guid[0,2] + '/' + guid[2,2] + '/' + guid + '_l.mp3'

    transparent = ActionController::Base.helpers.asset_path('transparent.png')
    logo = ActionController::Base.helpers.asset_path('multivideo_logo_180x29_bw.png')

    html << %Q(<div id="mediaContainer" class="opaque" style="display: none;">)
    html << %Q( <div id="mediaContainerPosition">)
    html << %Q(   <div id="resizable">)
    html << %Q(     <div id="mediaContainerSidebar"></div>)
    html << %Q(     <div id="mediaContainerButtons">)
    html << %Q(       <a title="Close" class="mediaContainer-mv-close" href="#"></a>)
    html << %Q(     </div>)
    html << %Q(     <div id="mediaContainerLine">)
    html << '         <div class="mediaContainer-mv-line"><img src="' + transparent + '" height="1" /></div>'
    html << %Q(     </div>)
    html << %Q(     <div id="mediaContainerInner">)
    html << %Q(       <div id="mediaPlayerContainer">)
    html << '           <div id="av_player" data-video-url="' + low_level_audio + '"></div>'
    html << %Q(       </div>)
    html << %Q(     </div>)
    html << '       <div class="mediaContainer-mv-logo"><img src="' + logo + '" /></div>'
    html << %Q(   </div>)
    html << %Q( </div>)
    html << %Q(</div>)

    html << %Q(<div id="singleThumbnailContainer">)
    html << %Q( <div class="thumbnailView">)
    html << '<img width="160" class="audioThumb thumb_001" alt="" border="0" src="' + thumbnail + '"><br/>'
    html << %Q( </div>)
    html << %Q(</div>)

    html << %Q(<div id="launchMultivideo">)
    html << %Q( <a href="#" class="btn btn-sm btn-default"><i class="fa fa-play-circle-o"></i> Play</a>)
    html << %Q(</div>)

    return html

  end

  def multivideo_multiThumbnail(xml)
    html = ""
    guid = xml.xpath("//mets:mets").first["OBJID"].gsub("osa:", "")

    low_level_handle = xml.xpath("//mets:fileGrp[@USE='low_level']//mets:fLocat").first["xlink:href"]
    thumbnails = xml.xpath("//mets:fileGrp[@USE='thumbnail']//mets:fLocat")

    types = detect_types(xml)

    mime = types[0]
    case mime
    when "video/x-flv"
      low_level_video = 'http://storage.osaarchivum.org/low/' + guid[0,2] + '/' + guid[2,2] + '/' + guid + '_l.flv'
    when "video/mp4"
      low_level_video = 'http://storage.osaarchivum.org/low/' + guid[0,2] + '/' + guid[2,2] + '/' + guid + '_l.mp4'
    end

    transparent = ActionController::Base.helpers.asset_path('transparent.png')
    logo = ActionController::Base.helpers.asset_path('multivideo_logo_180x29_bw.png')

    html << %Q(<div id="mediaContainer" class="opaque" style="display: none;">)
    html << %Q( <div id="mediaContainerPosition">)
    html << %Q(   <div id="resizable">)
    html << %Q(     <div id="mediaContainerSidebar"></div>)
    html << %Q(     <div id="mediaContainerButtons">)
    html << %Q(       <a title="Close" class="mediaContainer-mv-close" href="#"></a>)
    html << %Q(     </div>)
    html << %Q(     <div id="mediaContainerLine">)
    html << '         <div class="mediaContainer-mv-line"><img src="' + transparent + '" height="1" /></div>'
    html << %Q(     </div>)
    html << %Q(     <div id="mediaContainerInner">)
    html << %Q(       <div id="mediaPlayerContainer">)
    html << '           <div id="av_player" data-video-url="' + low_level_video + '"></div>'
    html << %Q(       </div>)
    html << %Q(     </div>)
    html << '       <div class="mediaContainer-mv-logo"><img src="' + logo + '" /></div>'
    html << %Q(   </div>)
    html << %Q( </div>)
    html << %Q(</div>)

    html << %Q(<div id="multiThumbnailContainer">)
    html << %Q( <div class="thumbnailView">)
    html << %Q(   <ul>)

    thumbnails.each_with_index do |thumbnail, index|
      html << '<li class="thumb_' + sprintf("%03d", index) + '"><img width="140" class="thumb_' + sprintf("%03d", index) + '" src="' + thumbnail["xlink:href"] + '"></li>'
    end

    html << %Q(   </ul>)
    html << %Q( </div>)
    html << %Q( <div class="smallThumbs">)
    html << %Q(   <div class="multiThumbs">)

    thumbnails.each_with_index do |thumbnail, index|
      html << '<img width="25" height="25" class="thumb_' + sprintf("%03d", index) + '" src="' + thumbnail["xlink:href"] + '">'
    end

    html << %Q(   </div>)
    html << %Q( </div>)
    html << %Q(</div>)

    html << %Q(<div id="launchMultivideo">)
    html << %Q( <a href="#" class="btn btn-sm btn-default"><i class="fa fa-play-circle-o"></i> Play</a>)
    html << %Q(</div>)

    return html
  end

end
