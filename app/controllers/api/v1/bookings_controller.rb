module Api
  module V1
    class BookingsController < ApplicationController
      def index
        authorize! :list, Train
        @trains = current_user.postmaster? ? Train : current_user.trains
        @trains = @trains.includes(:operator).where(status: "waiting")
        render json: @trains.as_json(only: %i[id name cost weight volume lines], methods: [:cost_per_kg, :operator_name])
          .sort_by { |train| train[:cost_per_kg] }, status: :ok
      end

      def create
        authorize! :create, Booking
        train = Train.find_by!(status: "waiting", id: params[:train_id])
        raise ApiException, :line_unavailable unless Line.exists?(booked: false, name: train.lines)
        raise ApiException, :parcels_not_available unless Parcel.exists?(status: "pending")
        BookTrainJob.perform_async(params[:train_id], current_user.id)
        render json: {message: "Train booking is scheduled"}, status: :created
      end
    end
  end
end
