desc 'Reprocess Spheres'
require 'progress_bar'

task reprocess_spheres: :environment do
  bar = ProgressBar.new(Sphere.all.count)

  Sphere.find_each do |sphere|
    begin
      sphere.process_panorama_upload = true
      sphere.panorama.cache_stored_file!
      sphere.panorama.retrieve_from_cache!(sphere.panorama.cache_name)
      sphere.panorama.recreate_versions!
      sphere.save!

      bar.increment!
    rescue => e
      puts  "ERROR: YourModel: #{sphere.id} -> #{e.to_s}"
    end
  end
end
