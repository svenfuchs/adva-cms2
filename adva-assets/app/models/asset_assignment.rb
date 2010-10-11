class AssetAssignment < ActiveRecord::Base
  belongs_to :asset
  belongs_to :image, :foreign_key => 'asset_id'
  belongs_to :video, :foreign_key => 'asset_id'
  belongs_to :assetable, :polymorphic => true

  accepts_nested_attributes_for :asset
  accepts_nested_attributes_for :image
  accepts_nested_attributes_for :video

  # acts_as_double_polymorphic_join(
  #   :guests => [:dogs, :cats],
  #   :eatens => [:cats, :birds]
  # )
end
