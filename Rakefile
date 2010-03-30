task :default => [:balls]

desc "work the shaft"
task :balls do
 system("./bin/gl_tail config/140proof_api.yml")
end

desc "see slow queries"
task :db do
 system("./bin/gl_tail config/140proof_db.yml")
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = '140proof-gltail'
    gemspec.summary = 'visualize 140 proof activity'
    gemspec.description = gemspec.summary
    gemspec.author = 'us'
    gemspec.email = 'jm3@140proof.com'
    gemspec.homepage = 'http://140proof.com'
    gemspec.add_dependency("net-ssh", "~> 2.0")
    gemspec.add_dependency("ruby-opengl", "~> 0.60")
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

