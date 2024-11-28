# frozen_string_literal: true

module Decidim
  module Superspace
    class SuperspaceParticipatorySpace < ApplicationRecord
      belongs_to :superspace,
                 foreign_key: "decidim_superspace_superspace_id",
                 class_name: "Decidim::Superspace::Superspace"

      belongs_to :participatory_space,
                 foreign_type: "participatory_space_type",
                 polymorphic: true,
                 optional: true

      validates :participatory_space_id, uniqueness: { scope: :participatory_space_type }
      validate :same_organization

      private

      def same_organization
        return if superspace.try(:organization) == participatory_space.try(:organization)

        errors.add(:superspace, :invalid)
        errors.add(:participatory_space, :invalid)
      end
    end
  end
end
