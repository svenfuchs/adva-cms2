require File.expand_path('../../test_helper', __FILE__)

module Tests
  module Cnet
    class CnetProductTest < Test::Unit::TestCase
      include CnetTestHelper

      def setup
        super
        import.load('import.fixtures.sql')
        Adva::Cnet::Importer::Product.new(:where => "ext_product_id = '100329'").run
        Adva::Cnet::Importer::Attribute.new(:where => "ext_value_id LIKE '%-100329-%'").run
        Adva::Cnet::Finalizer::Attribute.new.run
      end

      test "specification key names" do
        Globalize.with_locale(:de) do
          actual = ::Cnet::Product.first.specifications.map(&:name).map(&:to_s).sort
          expected = ["Abmessungen (Breite x Tiefe x Höhe)", "Allgemein", "Breite",
            "Datenübertragungsrate", "Details zu Service & Support", "Erweiterte Spezifikationen",
            "Erweiterung / Konnektivität", "Festplatte", "Formfaktor", "Formfaktor", "Gerätetyp",
            "Herstellergarantie", "Herstellergarantie", "Höhe", "Interner Datendurchsatz",
            "Kapazität", "Kapazität", "Kompatible Einschübe", "Leistung", "MTBF",
            "Max. Betriebstemperatur", "Merkmale", "Min Betriebstemperatur", "Mittlere Suchzeit",
            "Mittlere Wartezeit", "Nicht-korrigierbare Datenfehler", "Positionierungszeit",
            "Produktbeschreibung", "Produktzertifizierungen", "Puffergrösse", "Puffergröße",
            "Schnittstellen", "Schnittstellen Typ", "Schnittstellen Typ", "Schocktoleranz",
            "Service & Support", "Spindelgeschwindigkeit", "Spindelgeschwindigkeit",
            "Spur-zu-Spur-Positionierungszeit", "Start-/Stoppzyklen", "Technische Spezifikationen",
            "Tiefe", "Typ", "Umgebungsbedingungen", "Verschiedenes", "Vista-Zertifizierung",
            "Works with Windows Vista", "Zulässige Luftfeuchtigkeit im Betrieb", "Zuverlässigkeit",
            "Übertragungsrate Laufwerk"]
          assert_equal expected, actual
        end
      end

      test "specification value display_values" do
        Globalize.with_locale(:de) do
          actual = ::Cnet::Product.first.specifications.map(&:values).flatten.compact.map(&:display_value).sort
          expected = [
            "0 °C", 
            "0.8 ms", 
            "1 pro 10^14",
            "1 x ATA-133 - IDC 40-polig",
            "1 x intern - 3.5\" x 1/3H",
            "10.2 cm",
            "10.2 cm x 14.6 cm x 2.5 cm",
            "122 MBps",
            "133 MBps",
            "133 MBps (extern)",
            "14.6 cm",
            "2.5 cm",
            "250 GB",
            "250 GB",
            "3 Jahre Garantie",
            "3 Jahre Garantie",
            "3.5\" x 1/3H",
            "3.5\" x 1/3H",
            "4.17 ms",
            "5 - 90%",
            "50,000",
            "500,000 Stunde(n)",
            "60 °C",
            "63 g @ 2 ms (in Betrieb) / 350 g @ 2 ms (nicht in Betrieb)",
            "7200 rpm",
            "7200 rpm",
            "8 MB",
            "8 MB",
            "8.9 ms",
            "8.9 ms (Durchschnittlich) / 18 ms (Max)",
            "ATA-133",
            "ATA-133",
            "Begrenzte Garantie - 3 Jahre",
            "Das Logo \"Works with Windows Vista\" zeigt an, dass das Produkt vom Hersteller umfassend getestet wurde, um grundlegende Kompatibilität mit Windows Vista zu gewährleisten.",
            "Festplatte - intern",
            "Festplatte - intern",
            "Fluid-Dynamic-Bearing-(FDB)-Motor, NoiseGuard, SilentSeek-Technik",
            "S.M.A.R.T.",
            "Samsung SpinPoint P120 SP2514N - Festplatte - 250 GB - ATA-133",
            "Works with Windows Vista"]

          assert_equal expected, actual
        end
      end
    end
  end
end