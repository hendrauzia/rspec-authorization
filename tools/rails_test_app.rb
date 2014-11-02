class RailsTestApp
  attr_reader :path, :create_command, :destroy_command, :options
  attr_writer :template

  DEFAULT_TEMPLATE = "tools/rails_test_app/template.rb"

  def initialize(version, *options)
    @path    = "spec/.rails/rails-#{version}"
    @options = ( %w(--skip-bundle --skip-test-unit --skip-gemfile) + options ).uniq

    @create_command  = "bundle exec rails new #{path}"
    @destroy_command = "rm -rf #{path}"
  end

  def create
    system("#{create_command} #{template_param} #{option}") unless exists?
  end

  def exists?
    Dir.exists?(path)
  end

  def destroy
    system(destroy_command) if exists?
  end

  def template
    @template || DEFAULT_TEMPLATE
  end

  def template_param
    "--template=#{template}"
  end

  def option
    options.join(" ")
  end
end
