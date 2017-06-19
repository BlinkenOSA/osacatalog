module ThumbnailHelper

  def render_book_cover(document, options = {})

    book_isbns = get_book_isbns(document)

    locals = {
      document: document,
      css_class: book_isbns['isbn'].first,
      isbn: book_isbns['isbn'].first
    }

    begin
      render partial: "catalog/thumbnails/index_thumbnail_helper_library", locals: locals
    rescue ActionView::MissingTemplate
      nil
    end

  end

  def render_movie_cover(document)
    title = document['title']
    title = I18n.transliterate(title)
    title = title.gsub(".", "")
    title = title.gsub(":", "")
    title = title.gsub(",", "")
    title = title.gsub("#", "_")
    title = title.gsub("'", "_")
    title = title.gsub('"', "")
    title = title.downcase.gsub(" ", "_")

    cover = 'http://storage.osaarchivum.org/catalog/film_library/thumbnail/' + title[0] + '/' + title + '.jpg'

    begin
      if url_exist?(cover)
        image_tag(cover, class: "cover-image show")
      else
        render_emtpy_cover(document)
      end

    rescue
        render_emtpy_cover(document)
    end

  end

  def has_asset?(path)
    Rails.application.assets.find_asset(path) != nil
  end

  def render_archives_cover(document)
    # c = document['reference_code'].index('-')
    # if c
    #   img = document['reference_code'][0..c-1].gsub(" ", "_").downcase() + '.jpg'
    # else
    #   img = document['reference_code'].gsub(" ", "_").downcase() + '.jpg'
    # end

    ref_codes = document['reference_code'].gsub('HU OSA ', '').split('-')
    ref_codes_len = ref_codes.length

    ref_codes_len.downto(0).each { |i|
      cover = 'archival-unit-icons/hu_osa_' + ref_codes[0..i-1].join("-") + '.jpg'
      if has_asset?(cover)
        return image_path(cover)
      end
    }

    case document['description_level']
      when 'Fonds'
        return asset_path("thumbnail_placeholder_fonds.jpg")
      when 'Subfonds'
        return asset_path("thumbnail_placeholder_subfonds.jpg")
      when 'Series'
        return asset_path("thumbnail_placeholder_series.jpg")
    end
  end

  def render_emtpy_cover(document)
    case document['primary_type']
      when 'Book'
        image_tag("thumbnail_placeholder_book.jpg", class: "cover-image show")
      when 'Continuing Resource'
        image_tag("thumbnail_placeholder_newspaper.jpg", class: "cover-image show")
      when 'Moving Image'
        image_tag("thumbnail_placeholder_movie.jpg", class: "cover-image show")
    end
  end

  def render_dr_cover(document)
    item_id = document['id'].gsub("osa:", "")
    return image_tag("http://storage.osaarchivum.org/thumbnail/" + item_id[0,2] + "/" + item_id[2,2] + '/' + item_id + '_t_001.jpg', class: "cover-image show")
  end

  def render_fa_cover(document)
    ref_codes = document['series_reference_code'].gsub('HU OSA ', '').split('-')
    ref_codes.push(document['container_number'])
    ref_codes.push(document['sequence_number'])
    ref_codes_len = ref_codes.length

    ref_codes_len.downto(0).each { |i|
      cover = 'archival-unit-icons/hu_osa_' + ref_codes[0..i-1].join("-") + '.jpg'
      if has_asset?(cover)
        return image_path(cover)
      end
    }

    case document['description_level']
      when 'Folder'
        return asset_path("thumbnail_placeholder_folder.jpg")
      when 'Item'
        return asset_path("thumbnail_placeholder_item.jpg")
    end
  end
end

