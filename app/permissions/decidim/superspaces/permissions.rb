# frozen_string_literal: true

module Decidim
  module Superspaces
    class Permissions < Decidim::DefaultPermissions
      def permissions
        return Decidim::Superspaces::Admin::Permissions.new(user, permission_action, context).permissions if permission_action.scope == :admin

        superspace_action?

        permission_action
      end

      def superspace_action?
        return false unless permission_action.subject == :superspace
        return allow! if [:list, :read].include?(permission_action.action)

        disallow!
      end
    end
  end
end
