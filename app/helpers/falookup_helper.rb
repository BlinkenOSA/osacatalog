module FalookupHelper

  def fa_reverse_lookup(reference_code)
    units = reference_code.split('-').map(&:to_i)
    if units.all? {|i| i.is_a?(Integer) }
      case units.length
        when 1
          level = "Fonds"
        when 2
          level = "Subfonds"
        when 3
          level = "Series"
        else
          return false
          exit
      end

      reference_code = 'HU OSA ' + reference_code
      print reference_code
      id = FaLookup.new(reference_code, level).id
      return id
    else
      return false
    end
  end

end
