generate "devise:install"
generate "devise user"
generate "authorization:install"

rules = "config/authorization_rules.rb"

run "mkdir ../../../config"
run "ln -s ../spec/.rails/rails-#{Rails::VERSION::STRING}/#{rules} ../../../#{rules}"

generate "scaffold article user:references --skip-assets --skip-helper"

rake "db:migrate"
run "bundle exec rake db:migrate RAILS_ENV=test"

first_line = /\A.*/
last_line  = /^.*\Z/

inject_into_file "app/models/article.rb", %q{
}, after: first_line

inject_into_file "app/models/user.rb", %q{
  has_many :articles
}, after: first_line

inject_into_file "config/authorization_rules.rb", %q{
  role :editor do
    has_permission_on :articles, to: :manage
  end

  role :writer do
    has_permission_on :articles, to: %i(read create update)
  end

  role :premium do
    has_permission_on :articles, to: :read
  end

  role :user do
    has_permission_on :articles, to: :index
  end
}, after: first_line

inject_into_file "app/controllers/application_controller.rb", %q{
  before_action :authenticate_user!
}, after: first_line

inject_into_file "app/controllers/application_controller.rb", %q{
  def current_user
  end
}, before: last_line

inject_into_file "app/controllers/articles_controller.rb", %q{
  filter_resource_access
}, after: first_line

