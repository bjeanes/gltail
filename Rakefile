task :default => [:balls]

desc "work the shaft"
task :balls do
 system("./bin/gl_tail config/140proof_api.yml")
end

desc "see slow queries"
task :db do
 system("./bin/gl_tail config/140proof_db.yml")
end
