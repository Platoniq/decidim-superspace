# frozen_string_literal: true

module Decidim
  module Superspaces
    module Admin
      # This command is executed when the user changes a Superspace from the admin
      # panel.
      class UpdateSuperspace < Decidim::Command
        # Initializes a UpdateSuperspace Command.
        #
        # form - The form from which to get the data.
        # superspace - The current instance of the superspace to be updated.
        # current_user - The user who performs the action.
        def initialize(form, superspace, current_user)
          @form = form
          @superspace = superspace
          @current_user = current_user
        end

        # Updates the superspace if valid.
        #
        # Broadcasts :ok if successful, :invalid otherwise.
        def call
          return broadcast(:invalid) if form.invalid?

          transaction do
            update_superspace!
          end

          broadcast(:ok, superspace)
        end

        private

        attr_reader :form, :superspace, :current_user

        def update_superspace!
          Decidim.traceability.update!(
            superspace,
            current_user,
            title: form.title
          )
        end
      end
    end
  end
end
