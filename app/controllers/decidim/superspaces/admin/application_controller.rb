# frozen_string_literal: true

module Decidim
  module Superspaces
    module Admin
      # This controller is the abstract class from which all other controllers of
      # this engine inherit.
      #
      # Note that it inherits from `Decidim::Admin::ApplicationController`, which
      # override its layout and provide all kinds of useful methods.
      class ApplicationController < Decidim::Admin::ApplicationController
        register_permissions(::Decidim::Superspaces::Admin::ApplicationController,
                             ::Decidim::Superspaces::Admin::Permissions,
                             ::Decidim::Admin::Permissions)

        private

        def permission_class_chain
          ::Decidim.permissions_registry.chain_for(::Decidim::Superspaces::Admin::ApplicationController)
        end
      end
    end
  end
end
