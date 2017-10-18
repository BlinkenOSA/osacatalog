class NearbyOnShelf
  include Blacklight::Configurable
  include Blacklight::SearchHelper

  attr_reader :items

  def initialize(type, options)
    @items = get_nearby_items(options[:original_doc_id],options[:call_number_key],options[:call_number_reversed_key],options[:before],options[:after],options[:page])
  end

  protected

  def logger
    ::Rails.logger
  end

  def params
    {}
  end

  def get_nearby_items (original_doc_id, call_number_key, call_number_reversed_key, before, after, page)
    items = []

    if page.nil? or page.to_i == 0
      items << get_next_spines_from_field(call_number_reversed_key, "call_number_reversed_key", before, nil)
      items << get_spines_from_field_values([original_doc_id], "id").uniq
      items << get_next_spines_from_field(call_number_key, "call_number_key", after, nil)
    else
      if page.to_i < 0
        items << get_next_spines_from_field(call_number_reversed_key, "call_number_reversed_key",(before.to_i+1)*2, page.to_i)
      else page.to_i > 0
        items << get_next_spines_from_field(call_number_key, "call_number_key", after.to_i*2, page.to_i)
      end
    end

    items.flatten
  end

  # given a shelfkey or reverse shelfkey (for a lopped call number), get the
  #  text for the next "n" nearby items
  def get_next_spines_from_field(starting_value, field_name, how_many, page)
    number_of_items = how_many
    unless page.nil?
      if page < 0
        page = page.to_s[1,page.to_s.length]
      end
      number_of_items = how_many.to_i * page.to_i+1
    end
    desired_values = get_next_terms_for_field(starting_value, field_name, number_of_items)
    unless page.nil? or page.to_i == 0
      desired_values = desired_values.values_at((desired_values.length-how_many.to_i)..desired_values.length)
    end
    get_spines_from_field_values(desired_values, field_name)
  end

  # return an array of the next terms in the index for the indicated field and
  # starting term. Returned array does NOT include starting term.  Queries Solr (duh).
  def get_next_terms_for_field(starting_term, field_name, how_many=3)
    result = []
    # terms is array of one element hashes with key=term and value=count
    terms_array = get_next_terms(starting_term, field_name, how_many.to_i+1)
    terms_array.each { |term_hash|
      result << term_hash.keys[0] unless term_hash.keys[0] == starting_term
    }
    result
  end

  def get_spines_from_field_values(desired_values, field)
    results = []
    response, docs = get_solr_response_for_field_values(field, desired_values.compact)
    docs.each do |doc|
      results << {:doc => doc, :holding => doc["call_number"]}
    end
    results
  end

  def get_next_terms(curr_value, field, how_many)
    # TermsComponent Query to get the terms
    solr_params = {
      'terms' => 'true',
      'terms.fl' => field,
      'terms.lower' => curr_value,
      'terms.sort' => 'index',
      'terms.limit' => how_many
    }
    print "Params: "
    print solr_params
    solr_response =  Blacklight.default_index.connection.alphaTerms({params: solr_params})
    # create array of one element hashes with key=term and value=count
    result = []
    terms ||= solr_response['terms'] || []
    if terms.is_a?(Array)
      field_terms ||= terms[1] || []  # solr 1.4 returns array
    else
      field_terms ||= terms[field] || []  # solr 3.5 returns hash
    end
    # field_terms is an array of value, then num hits, then next value, then hits ...
    i = 0
    until result.length == how_many || i >= field_terms.length do
      term_hash = {field_terms[i] => field_terms[i+1]}
      result << term_hash
      i = i + 2
    end

    result
  end
end
