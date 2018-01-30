require 'critical-path-css-rails' unless Rails.env.production?

namespace :critical_path_css do
  desc 'Generate critical CSS for the routes defined'
  task generate: :environment do
    CriticalPathCss.generate_all
  end

  desc 'Clear all critical CSS from the cache'
  task clear_all: :environment do
    # Use the following for Redis cache implmentations
    CriticalPathCss.clear_matched('*')
    # Some other cache implementations may require the following syntax instead
    # CriticalPathCss.clear_matched(/.*/)
  end
end


desc "Generate critical CSS for the home route and spit out CSS file"
task critical: :environment do
  puts "Oooo, better run the server!" && return unless server_running?

  Rake::Task['assets:precompile'].invoke

  root_css = CriticalPathCss.generate_all["/"]

  File.open("#{Rails.root}/app/assets/stylesheets/critical.css", "w") do |f|
    f.write(root_css)
  end
end

def server_running?
  path = File.join(Rails.root, "tmp", "pids", "server.pid")
  pid = File.read(path).to_i

  begin
    Process.getpgid pid
  rescue Errno::ESRCH
    false
  end
end

# Rake::Task['assets:precompile'].enhance { Rake::Task['critical_path_css:generate'].invoke }
