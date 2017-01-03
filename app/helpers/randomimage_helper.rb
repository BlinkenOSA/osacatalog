module RandomimageHelper

  def randomized_archives_image
    images = ["archives01.jpg", "archives02.jpg", "archives03.jpg"]
    images[rand(images.size)]
  end

  def randomized_digitalrepository_image
    images = ["digital_repository01.jpg", "digital_repository02.jpg", "digital_repository03.jpg"]
    images[rand(images.size)]
  end

  def randomized_library_image
    images = ["library01.jpg", "library02.jpg", "library03.jpg"]
    images[rand(images.size)]
  end

  def randomized_filmlibrary_image
    images = ["film_library01.jpg", "film_library02.jpg", "film_library03.jpg"]
    images[rand(images.size)]
  end

end
