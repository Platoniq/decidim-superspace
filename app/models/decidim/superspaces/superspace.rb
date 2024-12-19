# frozen_string_literal: true

module Decidim
  module Superspaces
    class Superspace < ApplicationRecord
      include Decidim::Loggable
      include Decidim::Traceable
      include Decidim::TranslatableResource

      translatable_fields :title

      belongs_to :organization,
                 foreign_key: "decidim_organization_id",
                 class_name: "Decidim::Organization"

      def self.log_presenter_class_for(_log) = Decidim::Superspaces::AdminLog::SuperspacePresenter
    end
  end
end
