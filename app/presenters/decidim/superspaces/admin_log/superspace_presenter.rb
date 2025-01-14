# frozen_string_literal: true

module Decidim
  module Superspaces
    module AdminLog
      # This class holds the logic to present a `Decidim::Superspaces::Superspace`
      # for the `AdminLog` log.
      #
      # Usage should be automatic and you shouldn't need to call this class
      # directly, but here's an example:
      #
      #    action_log = Decidim::ActionLog.last
      #    view_helpers # => this comes from the views
      #    SuperspacePresenter.new(action_log, view_helpers).present
      class SuperspacePresenter < Decidim::Log::BasePresenter
        private

        def action_string
          case action
          when "create", "delete", "update"
            "decidim.superspaces.admin_log.superspace.#{action}"
          else
            super
          end
        end
      end
    end
  end
end
