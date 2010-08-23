require 'fileutils'
require 'net/ftp'

# require 'rubygems'
# require 'activerecord'
# require 'delayed_job'
#
# require 'cnet'
#
# # Note: We are not loading environment.rb so we have to explicitly set the
# #       timezone here to :utc, so that delayed_jobs run_at is not set to
# #       local time.
# ActiveRecord::Base.default_timezone = :utc
#
# Delayed::PerformableMethod.class_eval do
#   def dump(arg)
#     case arg
#     when Class, Module      then class_to_string(arg)
#     when ActiveRecord::Base then ar_to_string(arg)
#     else arg
#     end
#   end
# end

module Adva
  class Cnet
    class Downloader
      
      # TODO make this a thor task?
      
      class << self
        def process(server, options = {})
          unless server
            message = "you have to provide one of the following server names: #{SERVERS.keys.join(', ')}"
            raise ArgumentError.new(message)
          end

          Net::FTP.open(*SERVERS[server.to_sym]) do |connection|
            new(connection, options).process
          end
        end
      end

      SERVERS  = {
        :sk_staging => ['83.236.211.53', 'jabbathehut', '8rMoR1d8Tt8CkT89k'], # TODO extract to config file!
        :cnet       => ['janus.cnetdata.com', 'C06702', 'Pm285cz78u7'],
        :local      => ['sven.local', 'guest', 'guest']
      }

      attr_accessor :connection, :options

      def initialize(connection = nil, options = {})
        @connection = connection
        @options = options
        
        options[:target] or raise 'must provide a :target download directory'
      end

      def process
        log(:session_start, Time.now.strftime('%a, %Y-%m-%d %H:%M:%S'))
        return unless fresh_data?
        download
        confirm_download if !!options[:confirm_download]
        # request_import
      end

      protected

        def fresh_data?
          log(:check_freshness)
          connection.chdir('/ack')
          list = connection.list
          list = list.join if list.is_a?(Array)
          freshness = list.include?('dataout.txt')
          log(freshness ? :is_fresh : :is_stale)
          freshness
        end

        def download
          log(:start_download, archive_filename)
          connection.chdir('/download')
          connection.getbinaryfile('download.zip', archive_filename)
        end

        def confirm_download
          log(:start_confirmation)
          connection.chdir('/ack')
          connection.delete('dataout.txt')
        end

        def request_import
          log(:request_import)
          # Cnet.send_later(:stage_and_import, archive_filename)
          # Cnet.stage_and_import(archive_filename)
        end

        def archive_filename
          @archive_filename ||= "#{archive_dir}/#{current_day}.zip"
        end
        
        def archive_dir
          @archive_dir ||= "#{options[:target]}/#{current_month}".tap { |dir| FileUtils.mkdir_p(dir) }
        end
        
        def current_day
          Date.current.strftime('%Y-%m-%d')
        end
        
        def current_month
          Date.current.strftime('%Y/%m')
        end

        def log(message, *args)
          logger.info(message, *args)
        end

        def logger
          @logger = Adva::Cnet::Logger.new
        end
    end
  end
end