# frozen_string_literal: true

module Decidim
  module Superspaces
    # This cell renders the Grid (:g) superspace card
    # for a given instance of an Superspace
    class SuperspaceGCell < Decidim::CardGCell
      private

      def resource_path
        Decidim::Superspaces::Engine.routes.url_helpers.superspace_path(model)
      end

      def resource_image_url
        model.attached_uploader(:hero_image).url
      end
    end
  end
end
