require 'holdings/callnumber'

class Holdings
  def initialize(document)
    @document = document
    @item_display = @document[:item_display]
  end

  def find_by_barcode(barcode)
    callnumbers.find do |callnumber|
      callnumber.barcode == barcode
    end
  end

  def preferred_callnumber
    @preferred_callnumber ||= begin
      if @document[:preferred_barcode] &&
         (found_callnumber = find_by_barcode(@document[:preferred_barcode])).present?
        found_callnumber
      else
        callnumbers.first
      end
    end
  end

  def browsable_callnumbers
    callnumbers.select(&:browsable?).uniq(&:truncated_callnumber)
  end

  def callnumbers
    return [] unless @item_display.present?
    @callnumbers ||= @item_display.map do |item_display|
      Holdings::Callnumber.new(item_display)
    end.sort_by(&:full_shelfkey)
  end
end
