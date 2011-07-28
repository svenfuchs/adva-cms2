require 'pathname'

# Bundler gemfile support for local/remote workspaces/repositories for work in
# development teams.
#
# Usage:
#
#   # define paths to be searched for repositories:
#   workspace '~/.projects ~/Development/{projects,work}'
#
#   # define developer preferences for using local or remote repositories (uses ENV['user']):
#   developer :sven, :prefer => :local
#
#   # define repositories to be used for particular gems:
#   adva_cms  = repository('adva-cms2', :git => 'git@github.com:svenfuchs/adva-cms2.git', :ref => 'c2af0de')
#   adva_shop = repository('adva-shop', :source => :local)
#
#   # now use repositories to define gems:
#   adva_cms.gem  'adva-core'
#   adva_shop.gem 'adva-catalog'
#
#   # The gem definition will now be proxied to Bundler with arguments according
#   # to the setup defined earlier. E.g. as:
#
#   gem 'adva-core', :path => 'Development/projects/adva-cms2'                           # for developer 'sven'
#   gem 'adva-core', :git => 'git@github.com:svenfuchs/adva-cms2.git', :ref => 'c2af0de' # for other developers
#   gem 'adva-catalog', :path => 'Development/projects/adva-shop'                        # for all developers
#
#  One can also set an environment variable FORCE_REMOTE which will force remote
#  repositories to be used *except* when a repository was defined with :source => :local
#  which always forces the local repository to be used.
#
class Repository
  class << self
    def paths
      @paths ||= []
    end

    def path(*paths)
      paths.join(' ').split(' ').each do |path|
        self.paths.concat(Pathname.glob(File.expand_path(path)))
      end
    end

    def developer(name, preferences)
      developers[name] = preferences
      workspaces(preferences[:workspace])
    end

    def current_developer
      developers[ENV['USER'].to_sym] || {}
    end

    def developers(developers = nil)
      @developers ||= {}
    end
  end

  class Gem < Array
    def initialize(name, repository)
      if repository.local?
        super([name, { :path => repository.path.to_s }])
      else
        super([name, repository.options.dup])
      end
    end
  end

  attr_reader :bundler, :name, :options, :source

  def initialize(bundler, name, options)
    @bundler = bundler
    @name    = name
    @source  = options.delete(:source)
    @options = options
  end

  def gem(name)
    bundler.gem(*Gem.new(name, self))
  end

  def local?
    source == :local # && path
  end

  def source
    @source ||= forced_source || preferred_source || :remote
  end

  def forced_source
    :remote if ENV['FORCE_REMOTE']
  end

  def preferred_source
    self.class.current_developer[:prefer] || self.class.current_developer[name.to_sym]
  end

  def path
    @path ||= begin
      path = self.class.paths.detect { |path| path.join(name).exist? }
      path ? path.join(name) : Pathname.new('.')
    end
  end
end

def workspace(*paths)
  Repository.path(*paths)
end
alias :workspaces :workspace

def developer(name, preferences)
  Repository.developer(name, preferences)
end

def repository(*args)
  Repository.new(self, *args)
end
