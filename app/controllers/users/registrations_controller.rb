module Users
  class RegistrationsController < Devise::RegistrationsController
    include RackSessionFix

    private

    def respond_with(resource, _opts = {})
      resource.persisted? ? register_success(resource) : register_failed(resource)
    end

    def register_success(resource)
      render json: {
        status: {code: 200, message: "Signed up sucessfully."},
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }
    end

    def register_failed(resource)
      render json: {
        status: {message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"}
      }, status: :unprocessable_entity
    end
  end
end
