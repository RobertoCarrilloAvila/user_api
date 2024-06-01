# frozen_string_literal: true

module JsonResponse
  extend ActiveSupport::Concern

  included do
    before_action :ensure_json_format
  end

  private

  def ensure_json_format
    request.format = :json
  end
end
