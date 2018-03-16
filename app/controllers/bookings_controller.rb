class BookingsController < ApplicationController
  load_and_authorize_resource

  before_action :set_bookable
  before_action :add_breadcrumbs


  respond_to :html

  def create
    @booking.organisator = current_user
    @booking.save

    respond_with @booking, location: @booking.bookable
  end

  def update
    @booking.update(booking_params)
    respond_with @booking, location: @booking.bookable
  end

  private

  def booking_params
    params.require(:booking).permit(:start_at, :end_at)
  end

  def set_bookable
    @booking.bookable_id = params[params[:bookable_id]]
    @booking.bookable_type = params[:bookable_type]
  end

  def add_breadcrumbs
    add_breadcrumb @booking.bookable.model_name.human(count: :other), rooms_path

    add_breadcrumb @booking.bookable.title, @booking.bookable
    add_breadcrumb @booking.model_name.human, nil
    add_breadcrumb t('actions.new'),  [:new, @booking.bookable, :booking] if [:new,  :create].include? action_name.to_sym
    add_breadcrumb t('actions.edit'), [:edit, @booking.bookable, @booking] if [:edit, :update].include? action_name.to_sym
  end
end
