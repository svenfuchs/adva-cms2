class AssetAssignment < ActiveRecord::Base
  belongs_to :asset
  belongs_to :image, :foreign_key => 'asset_id'
  belongs_to :video, :foreign_key => 'asset_id'
  belongs_to :assetable, :polymorphic => true

  # acts_as_double_polymorphic_join(
  #   :guests => [:dogs, :cats], 
  #   :eatens => [:cats, :birds]
  # )
end