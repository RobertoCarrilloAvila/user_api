# frozen_string_literal: true

class UserQuery
  def self.search(params)
    params_with_predicates = params.transform_keys { |key| "#{key}_cont" }
    User.ransack(params_with_predicates)
        .result
        .order(id: :desc)
  end
end
