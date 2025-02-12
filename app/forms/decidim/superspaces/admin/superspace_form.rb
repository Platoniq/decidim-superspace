# frozen_string_literal: true

module Decidim
  module Superspaces
    module Admin
      # This class holds a Form to update superspaces from Decidim's admin panel.
      class SuperspaceForm < Decidim::Form
        include TranslatableAttributes

        translatable_attribute :title, String
        translatable_attribute :description, String
        attribute :locale
        attribute :hero_image
        attribute :assembly_ids
        attribute :participatory_process_ids
        attribute :conference_ids

        validates :title, translatable_presence: true
        validates :locale, presence: true

        alias organization current_organization
      end
    end
  end
end
