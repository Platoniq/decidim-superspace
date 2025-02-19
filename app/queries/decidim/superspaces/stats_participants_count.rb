# frozen_string_literal: true

module Decidim
  module Superspaces
    # TODO: Change the name of the class to StatsParticipantsCount
    class StatsParticipantsCount < Decidim::Query
      def self.for(superspace)
        return 0 unless superspace.is_a?(Decidim::Superspaces::Superspace)

        new(superspace).query
      end

      def initialize(superspace)
        @superspace = superspace
      end

      def query
        solution = [
          comments_query,
          debates_query,
          meetings_query,
          endorsements_query,
          project_votes_query,
          proposals_query,
          proposal_votes_query,
          survey_answer_query
        ].flatten.uniq.count

        data = [{ participatory_space: @superspace.to_s, stat_title: "participants_count", stat_value: solution }]

        data.map do |d|
          [d[:participatory_space].to_sym, d[:stat_title].to_sym, d[:stat_value].to_i]
        end
      end

      private

      attr_reader :participatory_space

      def participatory_space_ids
        @participatory_space_ids ||= @superspace.participatory_spaces.map(&:id)
      end

      def assemblies_ids
        @assemblies_ids ||= @superspace.assemblies.map(&:id)
      end

      def conferences_ids
        @conferences_ids ||= @superspace.conferences.map(&:id)
      end

      def participatory_spaces_comments_query
        Decidim::Comments::Comment
          .where(decidim_participatory_space_type: Decidim::ParticipatoryProcess.class.name)
          .where(decidim_participatory_space_id: participatory_space_ids)
          .pluck(:decidim_author_id)
          .uniq
      end

      def assemblies_comments_query
        Decidim::Comments::Comment
          .where(decidim_participatory_space_type: Decidim::Assembly.class.name)
          .where(decidim_participatory_space_id: assemblies_ids)
          .pluck(:decidim_author_id)
          .uniq
      end

      def conferences_comments_query
        Decidim::Comments::Comment
          .where(decidim_participatory_space_type: Decidim::Conference.class.name)
          .where(decidim_participatory_space_id: conferences_ids)
          .pluck(:decidim_author_id)
          .uniq
      end

      def comments_query
        return [] unless Decidim.module_installed?(:comments)

        [participatory_spaces_comments_query, assemblies_comments_query, conferences_comments_query].flatten.uniq
      end

      def assemblies_debates_query
        Decidim::Debates::Debate
          .where(
            component: assemblies_components,
            decidim_author_type: Decidim::UserBaseEntity.name
          )
          .not_hidden
          .pluck(:decidim_author_id)
          .uniq
      end

      def participatory_processes_debates_query
        Decidim::Debates::Debate
          .where(
            component: space_components,
            decidim_author_type: Decidim::UserBaseEntity.name
          )
          .not_hidden
          .pluck(:decidim_author_id)
          .uniq
      end

      def conferences_debates_query
        Decidim::Debates::Debate
          .where(
            component: conferences_components,
            decidim_author_type: Decidim::UserBaseEntity.name
          )
          .not_hidden
          .pluck(:decidim_author_id)
          .uniq
      end

      def debates_query
        return [] unless Decidim.module_installed?(:debates)

        [participatory_processes_debates_query, assemblies_debates_query, conferences_debates_query].flatten.uniq
      end

      def assemblies_meetings_query
        assemblies_meetings = Decidim::Meetings::Meeting.where(component: assemblies_components).not_hidden
        assemblies_registrations = Decidim::Meetings::Registration.where(decidim_meeting_id: assemblies_meetings).distinct.pluck(:decidim_user_id)
        assemblies_organizers = assemblies_meetings.where(decidim_author_type: Decidim::UserBaseEntity.name).distinct.pluck(:decidim_author_id)

        [assemblies_registrations, assemblies_organizers].flatten.uniq
      end

      def participatory_processes_meetings_query
        meetings = Decidim::Meetings::Meeting.where(component: @space_components).not_hidden
        registrations = Decidim::Meetings::Registration.where(decidim_meeting_id: meetings).distinct.pluck(:decidim_user_id)
        organizers = meetings.where(decidim_author_type: Decidim::UserBaseEntity.name).distinct.pluck(:decidim_author_id)

        [registrations, organizers].flatten.uniq
      end

      def conferences_meetings_query
        conferences_meetings = Decidim::Meetings::Meeting.where(component: conferences_components).not_hidden
        conferences_registrations = Decidim::Meetings::Registration.where(decidim_meeting_id: conferences_meetings).distinct.pluck(:decidim_user_id)
        conferences_organizers = conferences_meetings.where(decidim_author_type: Decidim::UserBaseEntity.name).distinct.pluck(:decidim_author_id)

        [conferences_registrations, conferences_organizers].flatten.uniq
      end

      def meetings_query
        return [] unless Decidim.module_installed?(:meetings)

        [participatory_processes_meetings_query + assemblies_meetings_query + conferences_meetings_query].uniq
      end

      def assemblies_endorsements_query
        Decidim::Endorsement
          .where(resource: assemblies_components)
          .pluck(:decidim_author_id)
          .uniq
      end

      def participatory_processes_endorsements_query
        Decidim::Endorsement
          .where(resource: space_components)
          .pluck(:decidim_author_id)
          .uniq
      end

      def conferences_endorsements_query
        Decidim::Endorsement
          .where(resource: conferences_components)
          .pluck(:decidim_author_id)
          .uniq
      end

      def endorsements_query
        [participatory_processes_endorsements_query, assemblies_endorsements_query, conferences_endorsements_query].flatten.uniq
      end

      def assemblies_proposals_query
        Decidim::Coauthorship
          .where(
            coauthorable: assemblies_proposals_components,
            decidim_author_type: Decidim::UserBaseEntity.name
          )
          .pluck(:decidim_author_id)
          .uniq
      end

      def participatory_processes_proposals_query
        Decidim::Coauthorship
          .where(
            coauthorable: proposals_components,
            decidim_author_type: Decidim::UserBaseEntity.name
          )
          .pluck(:decidim_author_id)
          .uniq
      end

      def conferences_proposals_query
        Decidim::Coauthorship
          .where(
            coauthorable: conferences_proposals_components,
            decidim_author_type: Decidim::UserBaseEntity.name
          )
          .pluck(:decidim_author_id)
          .uniq
      end

      def proposals_query
        return [] unless Decidim.module_installed?(:proposals)

        [participatory_processes_proposals_query, assemblies_proposals_query, conferences_proposals_query].flatten.uniq
      end

      def assemblies_proposal_votes_query
        Decidim::Proposals::ProposalVote
          .where(
            proposal: assemblies_proposals_components
          )
          .final
          .pluck(:decidim_author_id)
          .uniq
      end

      def participatory_processes_proposal_votes_query
        Decidim::Proposals::ProposalVote
          .where(
            proposal: proposals_components
          )
          .final
          .pluck(:decidim_author_id)
          .uniq
      end

      def conferences_proposal_votes_query
        Decidim::Proposals::ProposalVote
          .where(
            proposal: conferences_proposals_components
          )
          .final
          .pluck(:decidim_author_id)
          .uniq
      end

      def proposal_votes_query
        return [] unless Decidim.module_installed?(:proposals)

        [participatory_processes_proposal_votes_query, assemblies_proposal_votes_query, conferences_proposal_votes_query].flatten.uniq
      end

      def assemblies_project_votes_query
        Decidim::Budgets::Order.joins(budget: [:component])
                               .where(budget: {
                                        decidim_components: { id: assemblies_components.pluck(:id) }
                                      })
                               .pluck(:decidim_user_id)
                               .uniq
      end

      def participatory_processes_project_votes_query
        Decidim::Budgets::Order.joins(budget: [:component])
                               .where(budget: {
                                        decidim_components: { id: space_components.pluck(:id) }
                                      })
                               .pluck(:decidim_user_id)
                               .uniq
      end

      def conferences_project_votes_query
        Decidim::Budgets::Order.joins(budget: [:component])
                               .where(budget: {
                                        decidim_components: { id: conferences_components.pluck(:id) }
                                      })
                               .pluck(:decidim_user_id)
                               .uniq
      end

      def project_votes_query
        return [] unless Decidim.module_installed?(:budgets)

        [participatory_processes_project_votes_query, assemblies_project_votes_query, conferences_project_votes_query].flatten.uniq
      end

      def assemblies_survey_answer_query
        Decidim::Forms::Answer.newsletter_participant_ids(assemblies_components)
      end

      def participatory_processes_survey_answer_query
        Decidim::Forms::Answer.newsletter_participant_ids(space_components)
      end

      def conferences_survey_answer_query
        Decidim::Forms::Answer.newsletter_participant_ids(conferences_components)
      end

      def survey_answer_query
        [participatory_processes_survey_answer_query, assemblies_survey_answer_query, conferences_survey_answer_query].flatten.uniq
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
