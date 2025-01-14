# frozen_string_literal: true

module Decidim
  module Superspaces
    # This controller is the abstract class from which all other controllers of
    # this engine inherit.
    class ApplicationController < Decidim::ApplicationController
      register_permissions(::Decidim::Superspaces::ApplicationController,
                           ::Decidim::Superspaces::Permissions,
                           ::Decidim::Admin::Permissions,
                           ::Decidim::Permissions)

      def permission_class_chain
        ::Decidim.permissions_registry.chain_for(::Decidim::Superspaces::ApplicationController)
      end

      def permission_scope
        :public
      end
    end
  end
end
