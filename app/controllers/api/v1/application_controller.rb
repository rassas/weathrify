module Api
  module V1
    class ApplicationController < ::ActionController::API
      include Api::V1::Concerns::Authentication
    end
  end
end
