Rake::Task['db:seed'].enhance ['my_seed_task']
task :my_seed_task => :environment do
  Crimagify::Engine.load_seed
end