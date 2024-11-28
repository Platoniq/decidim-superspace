# frozen_string_literal: true

module Decidim
  module Superspace
    class Superspace < ApplicationRecord
      include Decidim::TranslatableResource

      translatable_fields :title

      belongs_to :organization,
                 foreign_key: "decidim_organization_id",
                 class_name: "Decidim::Organization"
    end
  end
end
