class Admin::AssetsController < Admin::BaseController
  before_filter :set_assets

  def resources
    Adva::Asset.all
  end

  private

  def set_assets
    @assets = Adva::Asset.all
  end
end