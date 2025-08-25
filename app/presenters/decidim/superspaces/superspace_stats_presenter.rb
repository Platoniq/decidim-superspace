# frozen_string_literal: true

module Decidim
  module Superspaces
    # This class holds the logic to present superspace stats.
    # It inherits from `Decidim::StatsPresenter` and overrides the methods
    # needed to adapt the stats to the superspace context.

    class SuperspaceStatsPresenter < Decidim::StatsPresenter
      include Decidim::IconHelper

      def collection
        highlighted_stats = participatory_space_participants_stats
        highlighted_stats.concat(participatory_space_followers_stats)
        highlighted_stats.concat(component_stats(priority: StatsRegistry::HIGH_PRIORITY))
        highlighted_stats.concat(component_stats(priority: StatsRegistry::MEDIUM_PRIORITY))
        highlighted_stats.concat(comments_stats(participatory_space_sym))
        highlighted_stats = highlighted_stats.reject(&:empty?)
        highlighted_stats = highlighted_stats.reject { |_stat_manifest, _stat_title, stat_number| stat_number.zero? }
        grouped_highlighted_stats = highlighted_stats.group_by(&:first)

        statistics(grouped_highlighted_stats)
      end

      private

      def participatory_space = __getobj__

      def participatory_processes
        @participatory_processes ||= participatory_space.participatory_processes + participatory_space.assemblies + participatory_space.conferences
      end

      def participatory_space_participants_stats
        Decidim::Superspaces::StatsParticipantsCount.for(participatory_space)
      end

      def participatory_space_followers_stats
        Decidim::Superspaces::StatsFollowersCount.for(participatory_space)
      end

      def published_components
        @published_components ||= Component.where(participatory_space: participatory_processes).published
      end

      def participatory_space_sym = :superspace
    end
  end
end
