guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})

  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^tools/(.+)\.rb$})   { |m| "spec/tools/#{m[1]}_spec.rb" }

  watch(%r{^lib/.+/matchers/.+\.rb$}) { "spec/controllers" }
  watch(%r{^controllers/(.+)\.rb$})   { |m| "spec/controllers/#{m[1]}_spec.rb" }
end

