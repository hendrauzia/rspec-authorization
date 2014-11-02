generate "authorization:install --create-user"

rules = "config/authorization_rules.rb"

run "mkdir ../../../config"
run "ln -s ../spec/.rails/rails-#{Rails::VERSION::STRING}/#{rules} ../../../#{rules}"

generate "scaffold post --skip-assets --skip-helper"
generate "migration AddUserIdToPosts user:references"

rake "db:migrate"

first_line = /\A.*/
last_line  = /^.*\Z/

inject_into_file "app/models/post.rb", %q{
  belongs_to :user
}, after: first_line

inject_into_file "app/models/user.rb", %q{
  has_many :posts
}, after: first_line

inject_into_file "config/authorization_rules.rb", %q{
  role :user do
    has_permission_on :posts, to: :manage
  end
}, after: first_line

inject_into_file "app/controllers/application_controller.rb", %q{
  def current_user
    User.where(id: session[:user_id]).presence
  end
}, before: last_line

inject_into_file "app/controllers/posts_controller.rb", %q{
  filter_resource_access
}, after: first_line

