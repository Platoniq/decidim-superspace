# frozen_string_literal: true

def initialize_homepage_content_blocks
  initializer "superspaces.content_blocks" do
    Decidim.content_blocks.register(:homepage, :highlighted_superspaces) do |content_block|
      content_block.cell = "decidim/superspaces/content_blocks/highlighted_superspaces"
      content_block.settings_form_cell = "decidim/superspaces/content_blocks/highlighted_superspaces_settings_form"
      content_block.public_name_key = "decidim.superspaces.content_blocks.highlighted_superspaces.name"

      content_block.settings do |settings|
        settings.attribute :max_results, type: :integer, default: 6
      end
    end
  end
end
