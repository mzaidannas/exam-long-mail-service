module Api
  module V1
    class ParcelsController < ApplicationController
      before_action :load_and_authorize_resource, except: %i[index create]

      def index
        authorize! :list, Parcel
        render json: ParcelSerializer.new(current_user.parcels), status: :ok
      end

      def show
        render json: ParcelSerializer.new(@parcel), status: :ok
      end

      def create
        authorize! :create, Parcel, "You are not authorized to add a parcel"
        parcel = current_user.parcels.create!(train_params)
        render json: ParcelSerializer.new(parcel), status: :created
      end

      def retrieve
        if @parcel.status == "delivered"
          @parcel.update!(status: :retrieved)
          render json: ParcelSerializer.new(@parcel), status: :accepted
        else
          raise ApiException, :parcel_not_shipped
        end
      end

      private

      def train_params
        params.require(:parcel).permit(:name, :cost, :weight, :volume, :lines)
      end

      def load_and_authorize_resource
        @parcel = Parcel.find(params[:id])
        authorize! :read, @parcel, "You do not have access to this parcel"
      end
    end
  end
end
