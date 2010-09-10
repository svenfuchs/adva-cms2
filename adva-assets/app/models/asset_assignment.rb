class AssetAssignment < ActiveRecord::Base
  belongs_to :asset
  belongs_to :assetable, :polymorphic => true
end