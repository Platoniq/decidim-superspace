# frozen_string_literal: true

module Decidim
  module Superspaces
    # This class holds the logic to present superspace stats.
    # It inherits from `Decidim::StatsPresenter` and overrides the methods
    # needed to adapt the stats to the superspace context.

    class SuperspaceStatsPresenter < Decidim::StatsPresenter
      include Decidim::IconHelper

      private

      def participatory_space = __getobj__

      def participatory_processes
        @participatory_processes ||= participatory_space.participatory_processes + participatory_space.assemblies + participatory_space.conferences
      end

      def participatory_space_participants_stats
        Decidim::Superspaces::StatsParticipantsCount.for(participatory_space)
      end

      def participatory_space_followers_stats(_conditions)
        Decidim::Superspaces::StatsFollowersCount.for(participatory_space)
      end

      def published_components
        @published_components ||= Component.where(participatory_space: participatory_processes).published
      end

      def participatory_space_sym = :superspace
    end
  end
end
