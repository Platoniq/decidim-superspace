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
          assembly_ids = form.assembly_ids
          participatory_process_ids = form.participatory_process_ids
          conference_ids = form.conference_ids
          Decidim.traceability.update!(
            superspace,
            current_user,
            title: form.title,
            hero_image: form.hero_image,
            locale: form.locale
          )
          update_associations(assembly_ids, participatory_process_ids, conference_ids)
        end

        def update_associations(assembly_ids, process_ids, conference_ids)
          @superspace.superspaces_participatory_spaces.destroy_all

          if assembly_ids.present?
            Decidim::Assembly.where(id: assembly_ids).each do |assembly|
              @superspace.superspaces_participatory_spaces.create!(
                participatory_space: assembly
              )
            end
          end

          if process_ids.present?

            Decidim::ParticipatoryProcess.where(id: process_ids).each do |process|
              @superspace.superspaces_participatory_spaces.create!(
                participatory_space: process
              )
            end
          end

          return if conference_ids.blank?

          Decidim::Conference.where(id: conference_ids).each do |conference|
            @superspace.superspaces_participatory_spaces.create!(
              participatory_space: conference
            )
          end
        end
      end
    end
  end
end
