class RailsTestApp
  attr_reader :path, :create_command, :destroy_command, :options

  def initialize(version, *options)
    @path    = "spec/.rails/rails-#{version}"
    @options = ( %w(--skip-bundle --skip-test-unit --skip-gemfile) + options ).uniq

    @create_command  = "bundle exec rails new #{path}"
    @destroy_command = "rm -rf #{path}"
  end

  def option
    options.join(" ")
  end

  def create
    system("#{create_command} #{option}") unless exists?
  end

  def destroy
    system(destroy_command) if exists?
  end

  def exists?
    Dir.exists?(path)
  end
end
