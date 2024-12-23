# frozen_string_literal: true

module Decidim
  module Superspaces
    module Admin
      # This class holds a Form to update superspaces from Decidim's admin panel.
      class SuperspaceForm < Decidim::Form
        include TranslatableAttributes

        translatable_attribute :title, String
        attribute :locale
        attribute :hero_image

        validates :title, translatable_presence: true
        validates :locale, presence: true


        alias organization current_organization
      end
    end
  end
end
