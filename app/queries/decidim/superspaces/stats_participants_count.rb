# frozen_string_literal: true

module Decidim
  module Superspaces
    class StatsParticipantsCount < Decidim::Query

      #This class is responsible for calculating the number of participants of a superspace.
      #The number of participants in a superspace is equal to the sum of participants of the participatory spaces that belong to the superspace.
      #If a user has participated in more than one participatory space, it will only be counted once.

      def self.for(superspace)
        return 0 unless superspace.is_a?(Decidim::Superspaces::Superspace)

        new(superspace).query
      end

      def initialize(superspace)
        @superspace = superspace
      end

      def query
        participatory_process_class_name=Decidim::ParticipatoryProcess.class.name
        assemblies_class_name=Decidim::Assembly.class.name
        conferences_class_name=Decidim::Conference.class.name

        solution = [
          comments_query(participatory_process_class_name, participatory_space_ids),
          comments_query(assemblies_class_name, assemblies_ids),
          comments_query(conferences_class_name, conferences_ids),
          debates_query(space_components),
          debates_query(assemblies_components),
          debates_query(conferences_components),
          meetings_query(space_components),
          meetings_query(assemblies_components),
          meetings_query(conferences_components),
          endorsements_query(space_components),
          endorsements_query(assemblies_components),
          endorsements_query(conferences_components),
          project_votes_query(space_components),
          project_votes_query(assemblies_components),
          project_votes_query(conferences_components),
          proposals_query(proposals_components),
          proposals_query(assemblies_proposals_components),
          proposals_query(conferences_proposals_components),
          proposal_votes_query(proposals_components),
          proposal_votes_query(assemblies_proposals_components),
          proposal_votes_query(conferences_proposals_components),
          survey_answer_query(space_components),
          survey_answer_query(assemblies_components),
          survey_answer_query(conferences_components),
        ].flatten.uniq.count

        data = [{ participatory_space: @superspace.to_s, stat_title: "participants_count", stat_value: solution }]

        data.map do |d|
          [d[:participatory_space].to_sym, d[:stat_title].to_sym, d[:stat_value].to_i]
        end
      end

      private

      def participatory_space_ids
        @participatory_space_ids ||= @superspace.participatory_processes.map(&:id)
      end

      def assemblies_ids
        @assemblies_ids ||= @superspace.assemblies.map(&:id)
      end

      def conferences_ids
        @conferences_ids ||= @superspace.conferences.map(&:id)
      end

      def comments_query(class_name, ids)
        return [] unless Decidim.module_installed?(:comments)

        Decidim::Comments::Comment
        .where(decidim_participatory_space_type: class_name)
        .where(decidim_participatory_space_id: ids)
        .pluck(:decidim_author_id)
        .uniq
      end

      def debates_query(components)
        return [] unless Decidim.module_installed?(:debates)

        Decidim::Debates::Debate
        .where(
          component: components,
          decidim_author_type: Decidim::UserBaseEntity.name
        )
        .not_hidden
        .pluck(:decidim_author_id)
        .uniq
      end

      def meetings_query(components)
        return [] unless Decidim.module_installed?(:meetings)

        meetings = Decidim::Meetings::Meeting.where(component: components).not_hidden
        registrations = Decidim::Meetings::Registration.where(decidim_meeting_id: meetings).distinct.pluck(:decidim_user_id)
        organizers = meetings.where(decidim_author_type: Decidim::UserBaseEntity.name).distinct.pluck(:decidim_author_id)

        [registrations, organizers].flatten.uniq
      end

      def endorsements_query(components)
        Decidim::Endorsement
          .where(resource: components)
          .pluck(:decidim_author_id)
          .uniq
      end

      def proposals_query(proposals_components)
        return [] unless Decidim.module_installed?(:proposals)

        Decidim::Coauthorship
          .where(
            coauthorable: proposals_components,
            decidim_author_type: Decidim::UserBaseEntity.name
          )
          .pluck(:decidim_author_id)
          .uniq
      end

      def proposal_votes_query(proposals_components)
        return [] unless Decidim.module_installed?(:proposals)

        Decidim::Proposals::ProposalVote
          .where(
            proposal: proposals_components,
          )
          .final
          .pluck(:decidim_author_id)
          .uniq
      end

      def project_votes_query(components)
        return [] unless Decidim.module_installed?(:budgets)

        Decidim::Budgets::Order.joins(budget: [:component])
                               .where(budget: {
                                        decidim_components: { id: components.pluck(:id) }
                                      })
                               .pluck(:decidim_user_id)
                               .uniq
      end

      def survey_answer_query(components)
        Decidim::Forms::Answer.newsletter_participant_ids(components)
      end

      def space_components
        Decidim::Component.where(participatory_space: @superspace.participatory_processes)
      end

      def assemblies_components
        Decidim::Component.where(participatory_space: @superspace.assemblies)
      end

      def conferences_components
        Decidim::Component.where(participatory_space: @superspace.conferences)
      end

      def proposals_components
        @proposals_components ||= Decidim::Proposals::FilteredProposals.for(space_components).published.not_hidden
      end

      def assemblies_proposals_components
        @assemblies_proposals_components ||= Decidim::Proposals::FilteredProposals.for(assemblies_components).published.not_hidden
      end

      def conferences_proposals_components
        @conferences_proposals_components ||= Decidim::Proposals::FilteredProposals.for(conferences_components).published.not_hidden
      end
    end
  end
end
