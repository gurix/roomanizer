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
    assign_creator_to_new_pastables
    @room.save

    respond_with @room
  end

  def update
    @room.update(room_params)
    assign_creator_to_new_pastables
    @room.save
    
    respond_with @room
  end

  def destroy
    @room.destroy
    respond_with @room
  end

  private

  def room_params
    params.require(:room).permit(:title, :floor_id, :lock_version, images_attributes: images_attributes)
  end

  def add_breadcrumbs
    add_breadcrumb Room.model_name.human(count: :other), rooms_path

    add_breadcrumb @room.title,       room_path(@room)      if [:show, :edit, :update].include? action_name.to_sym
    add_breadcrumb t('actions.new'),  new_room_path         if [:new,  :create].include?        action_name.to_sym
    add_breadcrumb t('actions.edit'), edit_room_path(@room) if [:edit, :update].include?        action_name.to_sym
  end
end
