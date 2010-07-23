require File.expand_path('../../../test/test_helper', __FILE__)

# require File.expand_path(File.dirname(__FILE__) + '/../../../adva/engines/adva_cms/test/test_helper')
# require File.dirname(__FILE__) + '/fixtures'
# require File.dirname(__FILE__) + "/contexts"
#
# module ContactsTestHelper
#   def assert_preferred(model, collection, message = nil)
#     assert_equal model, collection.select {|m| m.preferred}.first, message
#   end
#
#   private
#     def create_contact(attributes = {})
#       Contact.create({ :prefix      => 'Mr',
#                        :first_name  => 'John',
#                        :middle_name => 'Jack',
#                        :last_name   => 'Appleseed',
#                        :suffix      => 'Ph.D.',
#                        :born_on     => '1970-01-01',
#                        :photo       => 'http://gravatar.com/appleseed.jpg',
#                        :sound       => 'beep.wav',
#                        :nickname    => 'apples33d',
#                        :note        => 'Nerd',
#                        :url         => 'http://appleseed.com' }.merge(attributes))
#     end
#
#     def create_organization(attributes = {})
#       Org.create({ :name => 'Acme Ltd.',
#                    :logo => 'acme.jpg',
#                    :url  => 'http://acme.com' }.merge(attributes))
#     end
#
#     def create_email(attributes = {})
#       EmailInfo.create email_attributes.merge(:email_infoable => contact).merge(attributes)
#     end
#
#     def create_telephone(attributes = {})
#       Telephone.create telephone_attributes.merge(:telephoneable => contact).merge(attributes)
#     end
#
#     def create_address(attributes = {})
#       Address.create address_attributes.merge(:addressable => contact).merge(attributes)
#     end
#
#     def create_extended_address
#       create_address :delivery => 'Home',
#                      :pobox    => 'P.O. BOX 534',
#                      :extended => "1 Infinite Looooooop"
#     end
#
#     def create_todo(attributes = {})
#       Todo.create({ :summary     => "Buy the milk",
#                     :description => "Go to the grocery store and buy the milk",
#                     :due_at      => Time.now.midnight,
#                     :location    => "Grocery store" }.merge(attributes))
#     end
#
#     def create_started_todo
#       returning todo = create_todo do
#         todo.start!
#       end
#     end
#
#     # TODO DRY
#     def address
#       @address ||= Address.first
#     end
#
#     def contact
#       @contact ||= Contact.first
#     end
#
#     def telephone
#       @telephone ||= Telephone.first
#     end
#
#     def todo
#       @todo ||= Todo.first
#     end
#
#     def organization
#       @organization ||= Org.first
#     end
#
#     def email
#       @email ||= EmailInfo.first
#     end
#
#     def position
#       @position ||= Position.first
#     end
#
#     def another_contact
#       @another_contact ||= Contact.find_by_first_name('Alter')
#     end
#
#     def telephone_attributes
#       { :value    => "0039 089 1234567",
#         :location => 'Home' }
#     end
#
#     def email_attributes
#       { :value    => 'john@example.com',
#         :location => 'Home' }
#     end
#
#     def address_attributes
#       { :street      => "1 Infinite Loop",
#         :country     => "United States",
#         :locality    => "Cupertino",
#         :location    => "Work",
#         :postalcode  => "95014",
#         :region      => "California" }
#     end
#
#     def invalid_unicode_string
#       "\\&gt;&lt;&amp;/"
#     end
#
#     def roles
#       contact.positions.map(&:role).join(", ")
#     end
#
#     def vcard_string
#       "BEGIN:VCARD\nVERSION:3.0\nN:Doe;John;Jack;Mr.;Developer\nFN:Mr. John Jack Doe, Developer\nADR;TYPE=home,pref:;;Via dei fori imperiali\\, 52;Rome;Lazio;00100;Italy\nTEL;TYPE=home,pref:0039 089 1234567\nEMAIL;TYPE=home,pref:john-1982@example.com\nEND:VCARD\n"
#     end
# end
