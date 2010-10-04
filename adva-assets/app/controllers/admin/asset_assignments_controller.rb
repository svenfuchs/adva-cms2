class Admin::AssetsAssignmentsController < Admin::BaseController

  # TODO: why does inherited resources not guess the resource_class out of the box
  defaults :resource_class => AssetAssignment

  def destroy
    destroy!(:notice => "#{resource.asset.type} successfully deleted.") do |success, failure|
      # TODO: to be improved (use something better than request.referer???, e.g. return_to param)
      success.html do
        redirect_to request.referer
      end
    end
  end

end