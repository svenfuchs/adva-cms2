class Cnet::Product < ActiveRecord::Base
  set_table_name 'cnet_products'
  
  translates :description, :marketing_text, :table_name => 'cnet_product_translations'
  
  # class << self
  #   def default_image
  #     Cnet::DigitalContent.new(:url => '/noimage.jpg', :base_path => '/images')
  #   end
  # end
  # 
  # MANUFACTURER_ATR_ID = 'A00630'
  #
  # has_many :product_attributes,          :class_name => 'Cnet::ProductAttribute',         :foreign_key => 'cnet_product_id'
  # has_many :specifications,              :class_name => 'Cnet::Specification'
  # has_many :digital_content_assignments, :class_name => 'Cnet::DigitalContentAssignment', :foreign_key => 'cnet_product_id', :dependent => :destroy
  # has_many :digital_contents,            :class_name => 'Cnet::DigitalContent',           :through => :digital_content_assignments
  # 
  # belongs_to :product,                   :class_name => 'Sk::Product',                    :foreign_key => 'sk_product_id'
  # belongs_to :category,                  :class_name => 'Cnet::Category',                 :foreign_key => 'cnet_category_id'
  # belongs_to :manufacturer,              :class_name => 'Cnet::Manufacturer',             :foreign_key => 'cnet_manufacturer_id'
  # 
  # def name
  #   @name ||= description ? description.split(' - ').first : ''
  # end
  # 
  # def description_2
  #   @description ||= description ? description.split(' - ')[1..-1].join(', ') : ''
  # end
  # 
  # def default_image
  #   @default_image ||= begin
  #     image = category.default_image
  #     image.try(:exists?) ? image : self.class.default_image
  #   end
  # end
  # 
  # def image(type)
  #   (@images ||= {})[type.to_sym] ||= begin
  #     image = digital_contents.product_images.send(type).first
  #     image.try(:exists?) ? image : fallback_image(type)
  #   end
  # end
  # 
  # def images(type)
  #   digital_contents.product_images.send(type).select { |image| image.try(:exists?) }
  # end
  # 
  # IMAGE_TYPES = [:large, :medium, :small]
  # 
  # def fallback_image(type)
  #   fallback = IMAGE_TYPES[IMAGE_TYPES.index(type.to_sym) + 1]
  #   fallback ? image(fallback) : default_image
  # end
end
