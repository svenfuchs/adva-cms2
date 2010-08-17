require 'logger'

# Logger::Formatter.class_eval do
#   def call(severity, time, progname, msg)
#     msg2str("#{msg}\n")
#   end
# end

module Adva
  class Cnet
    class Logger < ::Logger
      MESSAGES = {
        :session_start      => "\n#{'-' * 80}\n\n%s Starting CNET download session.",
        :check_freshness    => "  [ Checking data freshness ]",
        :is_fresh           => "  [ Fresh data on server ]",
        :is_stale           => "  [ No fresh data on server ]",
        :start_download     => "  [ Downloading file from server to %s ]",
        :start_confirmation => "  [ Confirming download ]",
        :request_import     => "  [ Queuing import request ]"
      }
      
      class << self
        attr_writer :dir, :io
        
        def dir
          @dir ||= Rails.application.config.paths.log.to_a.first
        end
        
        def io
          @io ||= File.open("#{dir}/#{Rails.env}.import.cnet.log", 'a+').tap { |f| f.sync = true }
        end
      end

      def initialize
        super(self.class.io)
      end

      def info(message, *args)
        super(message.is_a?(Symbol) ? MESSAGES[message] % args : message)
      end
    end
  end
end