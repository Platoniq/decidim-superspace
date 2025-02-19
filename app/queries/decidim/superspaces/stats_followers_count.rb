# frozen_string_literal: true

module Decidim
  module Superspaces
    class StatsFollowersCount < Decidim::Query

      #This class is responsible for calculating the number of followers of a superspace.
      #The number of followers in a superspace is equal to the sum of the number of followers in all the participatory spaces that belong to the superspace.
      
      def self.for(superspace)
        return 0 unless superspace.is_a?(Decidim::Superspaces::Superspace)

        new(superspace).query
      end

      def initialize(superspace)
        @superspace = superspace
      end

      def query
        count = space_query + components_query

        data = [{ participatory_space: superspace.to_s, stat_title: "followers_count", stat_value: count }]

        data.map do |d|
          [d[:participatory_space].to_sym, d[:stat_title].to_sym, d[:stat_value].to_i]
        end
      end

      private

      attr_reader :superspace

      def components_query
        Decidim.component_manifests.sum do |component|
          component.stats
                   .filter(tag: :followers)
                   .with_context(space_components)
                   .map { |_name, value| value }
                   .sum
        end
      end

      def space_query
        Decidim.participatory_space_manifests.sum do |space|
          space.stats
               .filter(tag: :followers)
               .with_context(participatory_space_items)
               .map { |_name, value| value }
               .sum
        end
      end

      def participatory_space_items
        @participatory_space_items ||= superspace.participatory_spaces
      end

      def space_components
        @space_components ||= Decidim::Component.where(participatory_space: participatory_space_items).published
      end
    end
  end
end
