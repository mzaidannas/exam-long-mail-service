module Api
  module V1
    class TrainsController < ApplicationController
      before_action :load_and_authorize_resource, except: %i[index create]

      def index
        authorize! :list, Train
        render json: TrainSerializer.new(current_user.trains.includes(booking: :parcels)), status: :ok
      end

      def show
        render json: TrainSerializer.new(@train), status: :ok
      end

      def create
        authorize! :create, Train, "You are not authorized to create a train"
        train = current_user.trains.create!(train_params)
        render json: TrainSerializer.new(train), status: :created
      end

      def withdraw
        if %W[waiting reached].include?(@train.status)
          @train.update!(status: "withdrawn")
          render json: TrainSerializer.new(@train), status: :accepted
        else
          raise ApiException, "train_#{@train.status}".to_sym
        end
      end

      private

      def train_params
        params.require(:train).permit(:name, :cost, :weight, :volume, :lines)
      end

      def load_and_authorize_resource
        @train = Train.includes(:booking).find(params[:id])
        authorize! :read, @train, "You do not have access to this train"
      end
    end
  end
end
