class RoomsController < ApplicationController
  load_and_authorize_resource
  before_action :add_breadcrumbs
  provide_optimistic_locking
  respond_to :html

  def index
    @q = @rooms.ransack(params[:q])
    @rooms = @q.result(distinct: true)
  end

  def create
    @room.save

    respond_with @room
  end

  def update
    @room.update(room_params)
    respond_with @room
  end

  def destroy
    @room.destroy
    respond_with @room
  end

  private
  def room_params
    params.require(:room).permit(:title, :floor_id, :lock_version)
  end

  def add_breadcrumbs
    add_breadcrumb Room.model_name.human(count: :other), rooms_path

    add_breadcrumb @room.title,        user_path(@room)     if [:show, :edit, :update].include? action_name.to_sym
    add_breadcrumb t('actions.new'),  new_user_path         if [:new,  :create].include?        action_name.to_sym
    add_breadcrumb t('actions.edit'), edit_user_path(@room) if [:edit, :update].include?        action_name.to_sym
  end
end
