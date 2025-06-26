# frozen_string_literal: true

module Decidim
  module Superspaces
    # This query class filters all superspaces given an organization.
    class OrganizationSuperspaces < Decidim::Query
      def initialize(organization)
        @organization = organization
      end

      def query
        Decidim::Superspaces::Superspace.where(organization: @organization)
      end
    end
  end
end
