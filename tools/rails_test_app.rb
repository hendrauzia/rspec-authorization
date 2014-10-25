class RailsTestApp
  attr_reader :path, :command, :options

  def initialize(version, *options)
    @path    = "spec/.rails/rails-#{version}"
    @command = "bundle exec rails new #{path}"
    @options = ( %w(--skip-bundle --skip-test-unit --skip-gemfile) + options ).uniq
  end

  def option
    options.join(" ")
  end

  def create
    system("#{command} #{option}") unless exists?
  end

  def exists?
    Dir.exists?(path)
  end
end
