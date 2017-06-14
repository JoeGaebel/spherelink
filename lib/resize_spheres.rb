class ResizeSpheres
  def self.run
    history = []
    Sphere.all.each do |sphere|
      dimensions = self.dimensions(sphere.panorama.file.file)
      if dimensions[0] > SphereUploader::MAX_WIDTH.to_s
        sphere.panorama.recreate_versions!
        new_dimensions = self.dimensions(sphere.panorama.file.file)
        history << {
          old_dimensions: dimensions,
          new_dimensions: new_dimensions
        }
      end
    end

    history
  end

  def self.dimensions(file_path)
    `identify -format "%wx%h" #{file_path}`.split(/x/)
  end
end
