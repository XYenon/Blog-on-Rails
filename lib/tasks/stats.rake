# Note THIS IS some hackety hack code without tests. CodeStatistics class could be rewritten to be more configurable ...
task :stats => [:statsetup, :stats_assets]

# Setup specs / cuke & js for stats
task :statsetup do
  require 'rails/code_statistics'

  class CodeStatistics
    alias calculate_statistics_orig calculate_statistics

    def calculate_statistics
      @pairs.inject({}) do |stats, pair|
        if 3 == pair.size
          stats[pair.first] = calculate_directory_statistics(pair[1], pair[2]); stats
        else
          stats[pair.first] = calculate_directory_statistics(pair.last); stats
        end
      end
    end
  end
  # http://www.pervasivecode.com/blog/2007/06/28/hacking-rakestats-to-get-gross-loc/
  ::STATS_DIRECTORIES << ['Views', 'app/views', /\.(rhtml|erb|rb)$/]
  # ::STATS_DIRECTORIES << ['Static CSS', 'public/stylesheets', /\.css$/]

  # coffeescript
  # ::STATS_DIRECTORIES << ['App javascript', 'public/javascripts', /\.js$/]
  # ::STATS_DIRECTORIES << ['coffeescript specs', 'spec/javascripts', /\.coffee$/]

  # RSpec default
  ::STATS_DIRECTORIES << %w( Model\ specs spec/models ) if File.exist?('spec/models')
  ::STATS_DIRECTORIES << %w( View\ specs spec/views ) if File.exist?('spec/views')
  ::STATS_DIRECTORIES << %w( Controller\ specs spec/controllers ) if File.exist?('spec/controllers')
  ::STATS_DIRECTORIES << %w( Helper\ specs spec/helpers ) if File.exist?('spec/helpers')
  ::STATS_DIRECTORIES << %w( Library\ specs spec/lib ) if File.exist?('spec/lib')
  ::STATS_DIRECTORIES << %w( Routing\ specs spec/routing ) if File.exist?('spec/routing')
  ::STATS_DIRECTORIES << %w( Integration\ specs spec/integration ) if File.exist?('spec/integration')
  ::CodeStatistics::TEST_TYPES << "Model specs" if File.exist?('spec/models')
  ::CodeStatistics::TEST_TYPES << "View specs" if File.exist?('spec/views')
  ::CodeStatistics::TEST_TYPES << "Controller specs" if File.exist?('spec/controllers')
  ::CodeStatistics::TEST_TYPES << "Helper specs" if File.exist?('spec/helpers')
  ::CodeStatistics::TEST_TYPES << "Library specs" if File.exist?('spec/lib')
  ::CodeStatistics::TEST_TYPES << "Routing specs" if File.exist?('spec/routing')
  ::CodeStatistics::TEST_TYPES << "Integration specs" if File.exist?('spec/integration')

  # Cuke
  if File.exist?('features')
    ::STATS_DIRECTORIES << %w( Cucumber\ features features )
    ::CodeStatistics::TEST_TYPES << "Cucumber features"
  end

end

desc "prints assets files stats"
task :stats_assets do
  images = Dir.glob("**/*.jpg") + Dir.glob("**/*.png") + Dir.glob("**/*.gif")
  puts "Number of images assets: #{images.size}"
end