desc "Reset test rails app to clean state"
task :reset do
  %i(clean setup).each do |task|
    Rake::Task[task].invoke
  end
end
