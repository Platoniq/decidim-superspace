# frozen_string_literal: true

module Decidim
  module Superspaces
    module Admin
      # This command is executed when the user creates a Superspace from the admin
      # panel.
      class CreateSuperspace < Decidim::Command
        # Initializes a CreateSuperspace Command.
        #
        # form - The form from which to get the data.
        # current_user - The user who performs the action.
        def initialize(form, current_user)
          @form = form
          @current_user = current_user
        end

        # Creates the superspace if valid.
        #
        # Broadcasts :ok if successful, :invalid otherwise.
        def call
          return broadcast(:invalid) if form.invalid?

          transaction do
            create_superspace!
          end

          broadcast(:ok, @superspace)
        end

        private

        attr_reader :form, :current_user

        def create_superspace!
          attributes = {
            organization: form.current_organization,
            title: form.title,
            locale: form.locale,
            hero_image: form.hero_image
          }

          @superspace = Decidim.traceability.create!(
            Superspace,
            current_user,
            attributes
          )
        end
      end
    end
  end
end
