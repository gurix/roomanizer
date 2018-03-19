class WorkspacesController < ApplicationController
  load_and_authorize_resource
  before_action :add_breadcrumbs
  provide_optimistic_locking
  respond_to :html

  def index
    @q = @workspaces.ransack(params[:q])
    @workspaces = @q.result(distinct: true)
  end

  def new
    @workspace.room_id = params[:room_id]
  end

  def create
    assign_creator_to_new_pastables
    @workspace.save

    respond_with @workspace, location
  end

  def update
    @workspace.update(workspace_params)
    assign_creator_to_new_pastables
    @workspace.save

    respond_with @workspace, location
  end

  def destroy
    @workspace.destroy
    respond_with @workspace, location
  end

  private

  def location
    { location: params[:location] } if params[:location].present?
  end

  def workspace_params
    params.require(:workspace).permit(:title, :lock_version, :room_id, images_attributes: images_attributes)
  end

  def add_breadcrumbs
    add_breadcrumb Workspace.model_name.human(count: :other), workspaces_path
    add_breadcrumb @workspace.title,  workspace_path(@workspace)      if [:show, :edit, :update].include? action_name.to_sym
    add_breadcrumb t('actions.new'),  new_workspace_path         if [:new,  :create].include?        action_name.to_sym
    add_breadcrumb t('actions.edit'), edit_workspace_path(@workspace) if [:edit, :update].include?        action_name.to_sym
  end
end
