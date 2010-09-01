module Adva
  class Static
    class Setup
      attr_reader :source, :target, :host, :title, :github
      
      def initialize(options)
        @source = options[:source] || 'import'
        @target = options[:target] || 'export'
        @host   = options[:host]   || 'example.org'
        @title  = options[:title]  || 'Your site title'
        @github = options[:github]
      end
      
      def run
      end
    end
  end
end