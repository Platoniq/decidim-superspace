# frozen_string_literal: true

require "decidim/seeds"

module Decidim
  module Superspaces
    # Creates demo superspaces grouping the participatory spaces already seeded
    # in the organization. Decidim seeds the engines before the participatory
    # spaces, so this is run after `db:seed` instead of from `load_seed`.
    class Seeds < Decidim::Seeds
      SPACE_TYPES = {
        "assemblies" => "Decidim::Assembly",
        "participatory_processes" => "Decidim::ParticipatoryProcess",
        "conferences" => "Decidim::Conference"
      }.freeze

      def call
        print "Creating seeds for decidim-superspaces...\n" unless Rails.env.test? # rubocop:disable Rails/Output

        superspaces = Array.new([number_of_records, 2].max) { create_superspace! }

        participatory_spaces.each_with_index do |space, index|
          superspaces[index % superspaces.size].superspaces_participatory_spaces.create!(participatory_space: space)
        end

        superspaces.each { |superspace| set_content_blocks_order!(superspace) }
      end

      private

      def create_superspace!
        Decidim.traceability.create!(
          Decidim::Superspaces::Superspace,
          admin_user,
          organization:,
          title: Decidim::Faker::Localized.sentence(word_count: 3),
          description: Decidim::Faker::Localized.wrapped("<p>", "</p>") do
            Decidim::Faker::Localized.paragraph(sentence_count: 3)
          end,
          locale: organization.default_locale,
          hero_image:
        )
      end

      def participatory_spaces
        SPACE_TYPES.values.flat_map do |class_name|
          class_name.constantize.where(organization:).order(:id).to_a
        end
      end

      def set_content_blocks_order!(superspace)
        types = SPACE_TYPES.select { |_type, class_name| superspace.superspaces_participatory_spaces.exists?(participatory_space_type: class_name) }.keys

        superspace.update!(content_blocks_order: types + ["statistics"])
      end
    end
  end
end
