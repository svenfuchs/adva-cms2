require File.expand_path('../../test_helper', __FILE__)

module Tests
  module Cnet
    class DownloaderTest < Test::Unit::TestCase
      class MockConnection
        attr_accessor :list, :deleted

        def initialize(*list)
          @list = list.flatten
          @deleted = []
        end

        def chdir(dir)
        end

        def getbinaryfile(filename, target)
          FileUtils.cp(File.expand_path(File.dirname(__FILE__) + '/../../fixtures/' + filename), target)
        end

        def delete(file)
          @deleted << file
        end
      end

      attr_reader :archive_dir
      
      def setup
        @archive_dir = '/tmp/adva-cnet-test/archive'
        Adva::Cnet::Logger.io = StringIO.new
        super
      end

      def teardown
        Adva::Cnet::Logger.io = nil
        super
      end

      def downloader(*args)
        options    = args.extract_options!.reverse_merge(:target => archive_dir)
        connection = args.first || self.connection
        Adva::Cnet::Downloader.new(connection, options)
      end

      def connection(*args)
        MockConnection.new(*args)
      end
      
      def current_day
        Time.now.strftime('%Y-%m-%d')
      end
      
      def current_month
        Time.now.strftime('%Y/%m')
      end

      test "archive_dir" do
        expected = "#{archive_dir}/#{current_month}"
        actual   = downloader.send(:archive_dir)
        assert_equal expected, actual
      end
      
      test "archive_filename" do
        expected = "#{archive_dir}/#{current_month}/#{current_day}.zip"
        actual   = downloader.send(:archive_filename)
        assert_equal expected, actual
      end

      test "fresh_data? returns true if dataout.txt file exists" do
        assert downloader(connection('dataout.txt')).send(:fresh_data?), "fresh_data? should be true"
      end

      test "fresh_data? returns true if dataout.txt file does not exist" do
        assert !downloader.send(:fresh_data?), "fresh_data? should be false"
      end

      test "download downloads the download.zip from the given connection" do
        downloader(:confirm_download => true).send(:download)
        filename = downloader.send(:archive_filename)
        assert_equal true, File.exists?(filename), "file should have been downloaded"
      end
      
      test "process w/ :confirm_download => true confirms the download" do
        connection = self.connection('dataout.txt')
        downloader = downloader(connection, :confirm_download => true)
        downloader.process
        assert connection.deleted.include?('dataout.txt'), "dataout.txt should have been deleted but wasn't."
      end
      
      test "process w/o :confirm_download option given does not confirm the download" do
        connection = self.connection('dataout.txt')
        downloader = downloader(connection)
        downloader.process
        assert !connection.deleted.include?('dataout.txt'), "dataout.txt should not have been deleted but was."
      end
    end
  end
end