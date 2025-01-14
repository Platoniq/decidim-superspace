# frozen_string_literal: true

module Decidim
  module Superspaces
    module Admin
      # A command with all the business logic to destroy a superspace.
      class DestroySuperspace < Decidim::Command
        # Public: Initializes the command.
        #
        # superspace - The superspace to destroy
        # current_user - the user performing the action
        def initialize(superspace, current_user)
          @superspace = superspace
          @current_user = current_user
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form was not valid and we could not proceed.
        #
        # Returns nothing.
        def call
          destroy_superspace
          broadcast(:ok)
        rescue ActiveRecord::RecordNotDestroyed
          broadcast(:invalid)
        end

        private

        attr_reader :current_user

        def destroy_superspace
          Decidim.traceability.perform_action!(
            "delete",
            @superspace,
            current_user
          ) do
            @superspace.destroy!
          end
        end
      end
    end
  end
end
