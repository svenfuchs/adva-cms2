class Admin::ProductsController < Admin::BaseController
  nested_belongs_to :site, :catalog

  before_filter :build_asset, :only => [:new, :edit]

  helper_method :section

  def update
    assets_attributes = params['product'].delete('assets_attributes')
    product = Product.find(params['product']['id'])
    if product
      product.update_attributes(params['product'])
    
      if assets_attributes and assets_attributes['0'] and assets_attributes['0']['title'].present? and assets_attributes['0']['file'].present?
        asset = Asset.create(assets_attributes['0'].merge(:site_id => params[:site_id]))
        AssetAssignment.create!(:product => product, :asset => asset, :weight => params[:asset_assignment][:weight])
      end
    end
    redirect_to [:edit, :admin, site, section, product]
  end

  def create
    assets_attributes = params['product'].delete('assets_attributes')
    product = Product.new(params['product'].merge(:account_id => site.account_id))

    if product.save
      if assets_attributes and assets_attributes['0']
        asset = Asset.create!(assets_attributes['0'].merge(:site_id => params[:site_id]))
        AssetAssignment.create!(:product => product, :asset => asset, :weight => params[:asset_assignment][:weight])
      end
      redirect_to [:edit, :admin, site, section, product]
    else
      render :action => :new
    end
  end

  def section
    @section ||= site.sections.find(params['catalog_id'])
  end

  private

  def build_asset
    resource.assets.build
  end

end
