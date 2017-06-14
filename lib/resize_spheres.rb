class ResizeSpheres
  def self.run
    Sphere.all.each do |sphere|
      sphere.panorama.recreate_versions!
    end
  end
end
