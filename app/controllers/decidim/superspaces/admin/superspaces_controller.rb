# frozen_string_literal: true

module Decidim
  module Superspaces
    module Admin
      # This controller allows the create or update a superspace.
      class SuperspacesController < ApplicationController
        include TranslatableAttributes

        helper_method :superspaces, :superspace, :participatory_spaces_sort_url

        def index
          enforce_permission_to :index, :superspace
        end

        def new
          enforce_permission_to :create, :superspace
          @form = form(SuperspaceForm).instance
        end

        def edit
          enforce_permission_to(:update, :superspace, superspace:)
          @form = form(SuperspaceForm).from_model(superspace)
        end

        def create
          enforce_permission_to :create, :superspace
          @form = form(SuperspaceForm).from_params(params)

          CreateSuperspace.call(@form, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("superspaces.create.success", scope: "decidim.superspaces.admin")
              redirect_to superspaces_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("superspaces.create.invalid", scope: "decidim.superspaces.admin")
              render action: "new"
            end
          end
        end

        def update
          enforce_permission_to(:update, :superspace, superspace:)
          @form = form(SuperspaceForm).from_params(params)

          UpdateSuperspace.call(@form, superspace, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("superspaces.update.success", scope: "decidim.superspaces.admin")
              redirect_to superspaces_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("superspaces.update.invalid", scope: "decidim.superspaces.admin")
              render action: "edit"
            end
          end
        end

        def destroy
          enforce_permission_to(:destroy, :superspace, superspace:)

          DestroySuperspace.call(superspace, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("superspaces.destroy.success", scope: "decidim.superspaces.admin")
              redirect_to superspaces_path
            end
          end
        end

        def configure
          enforce_permission_to :update, :superspace
          @superspace = Superspace.find(params[:id])
          @participatory_space_types = build_participatory_space_types
        end

        def update_spaces_order
          enforce_permission_to :update, :superspace

          @superspace = Superspace.find(params[:id])
          order_types = params[:ids_order]

          if @superspace.update(participatory_spaces_order: order_types)
            head :ok
          else
            head :unprocessable_entity
          end
        end

        private

        def build_participatory_space_types
          types = []

          if @superspace.assemblies.any?
            types << {
              type: 'assemblies',
              count: @superspace.assemblies.count
            }
          end

          if @superspace.participatory_processes.any?
            types << {
              type: 'participatory_processes',
              count: @superspace.participatory_processes.count
            }
          end

          if @superspace.conferences.any?
            types << {
              type: 'conferences',
              count: @superspace.conferences.count
            }
          end


          if @superspace.participatory_spaces_order.present?
            ordered_types = []
            @superspace.participatory_spaces_order.each do |type_id|
              type_obj = types.find { |t| t[:id] == type_id }
              ordered_types << type_obj if type_obj
            end

            unordered_types = types.reject { |t| @superspace.participatory_spaces_order.include?(t[:id]) }
            ordered_types + unordered_types
          else
            types
          end
        end

        def superspace
          @superspace ||= filtered_superspaces.find(params[:id])
        end

        def superspaces
          @superspaces ||= filtered_superspaces.page(params[:page]).per(15)
        end

        def filtered_superspaces
          Superspace.where(organization: current_organization)
        end
      end
    end
  end
end
