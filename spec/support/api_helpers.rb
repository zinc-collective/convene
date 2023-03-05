# frozen_string_literal: true

module ApiHelpers
  module Path
    def self.included(path_definition)
      path_definition.after do |example|
        next if response.body.blank?
        example.metadata[:response][:content] = {
          "application/json" => {
            example: JSON.parse(response.body, symbolize_names: true)
          }
        }
      end
    end
  end
end
