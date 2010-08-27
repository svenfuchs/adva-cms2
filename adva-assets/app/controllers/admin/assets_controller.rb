class Admin::AssetsController < Admin::BaseController
  #defaults :resource_class => Asset,
  #         :collection_name => 'assets', :instance_name => 'asset',
  #         :route_collection_name => "site_assets", :route_instance_name => "site_asset" # ???

  def create
    asset = Asset.create(params[:asset])
    if params[:asset] and asset.valid?
      flash[:notice] = t(:'assets.flash.create.success', :name => asset.title)
      redirect_to admin_site_assets_path(site)
    else
      flash[:notice] = t(:'assets.flash.create.error', :name => asset.title)
      render :action => :new
    end
  end
end