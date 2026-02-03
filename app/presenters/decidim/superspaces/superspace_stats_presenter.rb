# frozen_string_literal: true

module Decidim
  module Superspaces
    # This class holds the logic to present superspace stats.
    # It inherits from `Decidim::StatsPresenter` and overrides the methods
    # needed to adapt the stats to the superspace context.

    class SuperspaceStatsPresenter < Decidim::StatsPresenter
      include Decidim::IconHelper

      def scope_entity
        participatory_space
      end

      def collection
        highlighted_stats = participatory_space_participants_stats
        highlighted_stats.concat(participatory_space_followers_stats)
        highlighted_stats.concat(component_stats(priority: StatsRegistry::HIGH_PRIORITY))
        highlighted_stats.concat(component_stats(priority: StatsRegistry::MEDIUM_PRIORITY))

        highlighted_stats = highlighted_stats.reject(&:blank?)

        highlighted_stats = highlighted_stats.reject do |stat|
          value = if stat.is_a?(Hash)
                    stat[:data]&.first
                  else
                    stat[2]
                  end
          value.to_i.zero?
        end

        grouped_highlighted_stats = highlighted_stats.group_by do |s|
          s.is_a?(Hash) ? s[:name] : s[1]
        end

        stats(grouped_highlighted_stats)
      end
      
      def stats(grouped_stats)
        grouped_stats.map do |name, stats_list|
          total_value = stats_list.sum do |stat|
            if stat.is_a?(Hash)
              stat[:data].is_a?(Array) ? stat[:data].sum : stat[:data].to_i
            else
              stat[2].to_i
            end
          end

          { name: name, data: [total_value] }
        end
      end

      private

      def participatory_space = __getobj__

      def participatory_processes
        @participatory_processes ||= participatory_space.participatory_processes +
                                     participatory_space.assemblies +
                                     participatory_space.conferences
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
