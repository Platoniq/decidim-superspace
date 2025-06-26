# frozen_string_literal: true

module Decidim
  module Superspaces
    module ContentBlocks
      class HighlightedSuperspacesCell < Decidim::ContentBlocks::HighlightedParticipatorySpacesCell
        delegate :current_user, to: :controller

        def highlighted_spaces
          @highlighted_spaces ||= Decidim::Superspaces::OrganizationSuperspaces
                                  .new(current_organization)
                                  .query
        end

        def i18n_scope
          "decidim.superspaces.pages.home.highlighted_superspaces"
        end

        def all_path
          Decidim::Superspaces::Engine.routes.url_helpers.superspaces_path
        end

        def max_results
          model.settings.max_results
        end

        private

        def block_id
          "highlighted-superspaces"
        end
      end
    end
  end
end
