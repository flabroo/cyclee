class LanesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @lanes = Lane.all
    @lane = Lane.last
    @parkinglocations = ParkingLocation.all
    @markers = @parkinglocations.geocoded.map do |location|
      if location.reports.present?
        {
          lat: location.latitude,
          lng: location.longitude,
          id: location.id,
          image_url: helpers.asset_url("square-parking-solid.svg"),
          flagged: true
          # info_window: render_to_string(partial: "info_window", locals: { location: location })
        }
      else
        {
          lat: location.latitude,
          lng: location.longitude,
          id: location.id,
          image_url: helpers.asset_url("square-parking-solid.svg")
          # info_window: render_to_string(partial: "info_window", locals: { location: location })
        }
      end
    end
  end

  def show
    @lane = Lane.find_by(objectid: params[:id])
    @reviews = @lane.reviews.reverse
    @ratings = []
    @reviews.each do |review|
      @ratings << review.rating
    end
    @avgrating = @ratings.length.zero? ? 0 : @ratings.sum / @ratings.length

    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: "lanes/show", locals: { lane: @lane, reviews: @reviews, ratings: @ratings, avgrating: @avgrating }, formats: [:html] }
    end
  end

  def sample
  end
end
