# frozen_string_literal: true

module Decidim
  module Superspaces
    class Superspace < ApplicationRecord
      include Decidim::Loggable
      include Decidim::Traceable
      include Decidim::TranslatableResource
      include Decidim::HasUploadValidations

      has_one_attached :hero_image
      validates_upload :hero_image, uploader: Decidim::HeroImageUploader

      translatable_fields :title

      has_many :superspaces_participatory_spaces, foreign_key: "decidim_superspaces_superspace_id", dependent: :destroy

      belongs_to :organization,
                 foreign_key: "decidim_organization_id",
                 class_name: "Decidim::Organization"

      def participatory_spaces
        superspaces_participatory_spaces.map(&:participatory_space)
      end

      def assemblies
        find_spaces_by_type("Decidim::Assembly")
      end

      def participatory_processes
        find_spaces_by_type("Decidim::ParticipatoryProcess")
      end

      def conferences
        find_spaces_by_type("Decidim::Conference")
      end

      def self.log_presenter_class_for(_log) = Decidim::Superspaces::AdminLog::SuperspacePresenter

      private

      def find_spaces_by_type(type)
        superspaces_participatory_spaces.where(participatory_space_type: type).map(&:participatory_space)
      end
    end
  end
end
