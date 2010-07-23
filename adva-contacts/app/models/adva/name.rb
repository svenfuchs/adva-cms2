module Adva
  class Name
    attr_reader :given, :family

    def initialize(prefix, given, additional, family, suffix)
      @prefix, @given, @additional, @family, @suffix = prefix, given, additional, family, suffix
    end

    def prefix
      @prefix || ''
    end
  
    def additional
      @additional || ''
    end
  
    def suffix
      @suffix || ''
    end

    # def to_vcard
    #   returning n = Vpim::Vcard::Name.new do
    #     n.prefix, n.given, n.additional, n.family, n.suffix = prefix, given, additional, family, suffix
    #   end
    # end
    #
    # it doesn't work
    # def to_vcard
    #   Vpim::Vcard::Name.new do |n|
    #     n.prefix, n.given, n.additional, n.family, n.suffix = prefix, given, additional, family, suffix
    #   end
    # end
  end
end