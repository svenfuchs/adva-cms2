require File.expand_path('../../test_helper', __FILE__)

module Tests
  module Cnet
    class OriginTest < Test::Unit::TestCase
      attr_reader :origin, :tmp, :tables

      def setup
        Adva.out = $stdout
        @tables  = %w(cds_prod cds_mktde cds_stdnde cds_mspecde cds_mvocde cds_especde cds_evocde)
        @origin  = Adva::Cnet::Connections.origin
        @tmp     = Adva::Cnet::Connections.tmp
        super
      end

      def teardown
        tmp_path.join('test.origin.fixtures.sql').unlink rescue Errno::ENOENT
        super
      end

      def tmp_path
        Pathname.new('/tmp/adva-cnet_test/db').tap { |path| path.mkpath }
      end

      test "preparing the origin database from cds_prod files works" do
        tables.each { |table| assert origin.count(table) > 0 }
      end

      test "extracting fixtures from the origin database to the tmp database works" do
        Adva::Tasks::Cnet::Origin::Fixtures::Extract.new([origin, tmp]).invoke_all
        tables.each { |table| assert tmp.count(table) > 0 }
      end

      test "dumping fixtures from the tmp database to a sql file works" do
        Adva::Tasks::Cnet::Origin::Fixtures::Extract.new([origin, tmp]).invoke_all
        target = tmp_path.join('test.origin.fixtures.sql')
        Adva::Tasks::Cnet::Sql::Dump.new([tmp, target]).invoke_all
        fixtures = target.open { |f| f.read }
        tables.each { |table| assert_match %r(INSERT INTO #{table}), fixtures }
      end

      test "loading cnet data fixtures to the tmp database works" do
        Adva::Tasks::Cnet::Origin::Fixtures::Extract.new([origin, tmp]).invoke_all
        target = tmp_path.join('test.origin.fixtures.sql')
        Adva::Tasks::Cnet::Sql::Dump.new([tmp, target]).invoke_all
        tmp.clear!

        tmp.load(tmp_path.join('test.origin.fixtures.sql'))
        tables.each { |table| assert tmp.count(table) > 0 }

        # cds_prod
        assert_equal '100329', tmp.select_value(%(SELECT "ProdID" FROM cds_prod ORDER BY "ProdID" LIMIT 1))

        # cds_stdnde
        stdn = origin.select_value(%(SELECT "Description" FROM cds_stdnde WHERE "ProdID" = '100329' ORDER BY "ProdID" LIMIT 1))
        assert_equal 'Samsung SpinPoint P120 SP2514N - Festplatte - 250 GB - intern - 3.5" - ATA-133 - 7200 rpm - Puffer: 8 MB', stdn

        # cds_mktde
        mkt = origin.select_value(%(SELECT "Description" FROM cds_mktde
          WHERE "MktID" = (SELECT "MktID" FROM cds_prod WHERE "ProdID" = '100329' ORDER BY "ProdID" LIMIT 1) ORDER BY "MktID" LIMIT 1))
        assert_equal 'Mit den Samsung SpinPoints erhalten Anwender höchste Speicherdichte und rasanten Datentransfer ' +
                     'bei verblüffend geringer Geräuschentwicklung - ideal für Multimedia-Anwendungen und grafisch ' +
                     'aufwändige Computerspiele.', mkt

        # cds_mspecde
        hdr_id, body_id = origin.select_all(%(SELECT "HdrID", "BodyID" FROM cds_mspecde 
          WHERE "ProdID" = '100329' ORDER BY "ProdID", "HdrID", "BodyID" LIMIT 1)).first.values_at('HdrID', 'BodyID')
        assert_equal ["T0000002", "B0774481"], [hdr_id, body_id]
        hdr  = origin.select_value(%(SELECT "Text" FROM cds_mvocde WHERE "ID" = 'T0000002' ORDER BY "ID" LIMIT 1))
        body = origin.select_value(%(SELECT "Text" FROM cds_mvocde WHERE "ID" = 'B0774481' ORDER BY "ID" LIMIT 1))

        assert_equal 'Produktbeschreibung', hdr
        assert_equal 'Samsung SpinPoint P120 SP2514N - Festplatte - 250 GB - ATA-133', body

        # cds_especde
        sect_id, hdr_id, body_id = origin.select_all(%(SELECT "SectID", "HdrID", "BodyID" FROM cds_especde
          WHERE "ProdID" = '100329' ORDER BY "ProdID", "SectID", "HdrID", "BodyID" LIMIT 1)).first.values_at('SectID', 'HdrID', 'BodyID')
        assert_equal ['H0000002', 'T0000018', 'B0000508'], [sect_id, hdr_id, body_id]

        sect = origin.select_value(%(SELECT "Text" FROM cds_evocde WHERE "ID" = 'H0000002' ORDER BY "ID" LIMIT 1))
        hdr  = origin.select_value(%(SELECT "Text" FROM cds_evocde WHERE "ID" = 'T0000018' ORDER BY "ID" LIMIT 1))
        body = origin.select_value(%(SELECT "Text" FROM cds_evocde WHERE "ID" = 'B0000508' ORDER BY "ID" LIMIT 1))

        assert_equal 'Allgemein', sect
        assert_equal 'Breite', hdr
        assert_equal '10.2 cm', body
      end
    end
  end
end