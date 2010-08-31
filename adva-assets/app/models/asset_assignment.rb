class AssetAssignment < ActiveRecord::Base
  belongs_to :product, :foreign_key => :obj_id # FIXME :counter_cache => 'assets_count'
  belongs_to :asset

  validates :obj_id, :asset_id, :presence => true
  validate_on_create :check_for_dupe_content_and_asset

  protected
    def check_for_dupe_content_and_asset
      unless self.class.count(:all, :conditions => ['obj_id = ? and asset_id = ?', obj_id, asset_id]).zero?
        errors.add_to_base I18n.t('assets.validation.duplicate', :obj => product.name, :asset => asset.title)
      end
    end
end
