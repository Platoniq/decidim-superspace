# frozen_string_literal: true

module Decidim
  module Superspaces
    module ContentBlocks
      class HighlightedSuperspacesSettingsFormCell < Decidim::ViewModel
        alias form model

        def content_block
          options[:content_block]
        end

        def label
          I18n.t("decidim.superspaces.admin.content_blocks.highlighted_superspaces.max_results")
        end
      end
    end
  end
end
