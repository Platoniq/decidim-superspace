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

        def create_associations(assemblies_ids, participatory_processes_ids, conference_ids)
          Decidim::Assembly.where(id: assemblies_ids).each do |assembly|
            @superspace.superspaces_participatory_spaces.create!(
              participatory_space: assembly
            )
          end

          Decidim::ParticipatoryProcess.where(id: participatory_processes_ids).each do |process|
            @superspace.superspaces_participatory_spaces.create!(
              participatory_space: process
            )
          end

          Decidim::Conference.where(id: conference_ids).each do |conference|
            @superspace.superspaces_participatory_spaces.create!(
              participatory_space: conference
            )
          end
        end

        def create_superspace!
          attributes = {
            organization: form.current_organization,
            title: form.title,
            description: form.description,
            locale: form.locale,
            hero_image: form.hero_image,
            show_statistics: form.show_statistics
          }

          @superspace = Decidim.traceability.create!(
            Superspace,
            current_user,
            attributes
          )

          create_associations(form.assembly_ids, form.participatory_process_ids, form.conference_ids)
        end
      end
    end
  end
end
