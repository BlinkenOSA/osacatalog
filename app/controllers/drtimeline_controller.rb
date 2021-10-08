require 'uri'
require 'net/http'
require 'htmlentities'
require 'json'

class DrtimelineController < ApplicationController
  layout 'osacatalog'

  def index
  end

  def get_data_by_date
    collection = params[:collection]
    year = params[:year].to_i
    month = params[:month].to_i
    direction = params[:dir]
    date_filter = []

    if collection == 'all'
      collection_filter = ''
    else
      collection_filter = 'and $object <info:fedora/fedora-system:def/relations-external#isMemberOfCollection> <info:fedora/%s>' % collection
    end

    # year = 0 and month = 0
    if year == 0 and month == 0
      date_filter = ''
    # year != 0 and month = 0
    elsif year != 0 and month == 0
      (1..12).each do |month|
        days = Time.days_in_month(month, year)
        (1..days).each do |day|
          date_filter << "$object <dc:date> '%4d-%02d-%02d'" % [year, month, day]
        end
      end
    # year != 0 and month != 0
    elsif year != 0 and month != 0
      days = Time.days_in_month(month, year)
      (1..days).each do |day|
        date_filter << "$object <dc:date> '%4d-%02d-%02d'" % [year, month, day]
      end
    end

    unless date_filter.empty?
      date_filter = 'and (' + date_filter.join(' or ') + ')'
    end

    if params[:page]
      if params[:page] == '1'
        limit = 29
        offset = 0
      else
        limit = 29
        if direction == 'forward'
          offset = params[:page].to_i*29-28
        else
          offset = (params[:page].to_i-1)*29
        end
      end
    else
      limit = 30
      offset = 0
    end

    timeline_json = {}
    events = []

    riquery = %Q(select $title $pid $date $description
               from    <#ri>
               where   $object <fedora-model:state> <info:fedora/fedora-system:def/model#Active>
               and     ($object <fedora-model:hasModel> <info:fedora/osa:cm-item-arc>
               or      $object <fedora-model:hasModel> <info:fedora/osa:cm-item-lib>)
               and     $object <dc:identifier> $pid
               and     $object <dc:title> $title
               and     $object <dc:date> $date
               and     $object <dc:description> $description
               %s
               %s
               order by $date $title
               limit %d
               offset %d)

    uri = URI(Constants::FEDORA_RISEARCH_URL)
    query = riquery % [collection_filter, date_filter, limit.to_i, offset.to_i]
    res = Net::HTTP.post_form(uri, 'type' => 'tuples', 'lang' => 'itql', 'format' => 'json', 'query' => query)
    json = JSON.parse(res.body)

    coder = HTMLEntities.new

    json["results"].each do |element|
      media = {}
      start_date = {}
      text = {}

      unique_id = element["pid"]

      media["url"] = "https://hdl.handle.net/10891/" + element["pid"] + '_t_001'
      media["thumbnail"] = media["url"]

      ymd = element["date"].split("-")
      start_date["month"] = ymd[1].to_i
      start_date["day"] = ymd[2].to_i
      start_date["year"] = ymd[0].to_i

      text["headline"] = '<a href="' + Constants::SITE_URL + '/catalog/' + element["pid"] + '">' + element["title"] + '</a>'
      if element["description"] == ""
        text["text"] = ' '
      else
        text["text"] = coder.decode(element["description"])
      end

      events.push({"media" => media, "start_date" => start_date, "text" => text, "unique_id" => unique_id})

    end

    timeline_json["events"] = events

    render json: JSON.generate(timeline_json)
    #render json: timeline_json.to_s.html_safe
  end

  def get_dates_for_collection
    collection = params[:collection]
    date_json = {}
    start_date = {}
    end_date = {}

    riquery = %Q(select $date
               from    <#ri>
               where   $object <fedora-model:state> <info:fedora/fedora-system:def/model#Active>
               and     ($object <fedora-model:hasModel> <info:fedora/osa:cm-item-arc>
               or      $object <fedora-model:hasModel> <info:fedora/osa:cm-item-lib>)
               and     $object <dc:date> $date
               %s
               order by $date %s
               limit 1)

     if collection == 'all'
       collection_filter = ''
     else
       collection_filter = 'and $object <info:fedora/fedora-system:def/relations-external#isMemberOfCollection> <info:fedora/%s>' % collection
     end

     uri = URI.parse(Constants::FEDORA_RISEARCH_URL)
     params = {'type' => 'tuples', 'lang' => 'itql', 'format' => 'json', 'query' => riquery % [collection_filter, "asc"]}
     uri.query = URI.encode_www_form(params)
     json = JSON.parse(Net::HTTP.get(uri))

     json["results"].each do |element|
       ymd = element["date"].split('-')
       start_date["month"] = ymd[1].to_i
       start_date["day"] = ymd[2].to_i
       start_date["year"] = ymd[0].to_i
     end

     params = {'type' => 'tuples', 'lang' => 'itql', 'format' => 'json', 'query' => riquery % [collection_filter, "desc"]}
     uri.query = URI.encode_www_form(params)
     json = JSON.parse(Net::HTTP.get(uri))

     json["results"].each do |element|
       ymd = element["date"].split('-')
       end_date["month"] = ymd[1].to_i
       end_date["day"] = ymd[2].to_i
       end_date["year"] = ymd[0].to_i
     end

     date_json = {"start_date" => start_date, "end_date" => end_date}

     render json: date_json
  end



end
