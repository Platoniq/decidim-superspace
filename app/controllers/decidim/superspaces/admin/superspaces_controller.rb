# frozen_string_literal: true

module Decidim
  module Superspaces
    module Admin
      # This controller allows the create or update a superspace.
      class SuperspacesController < ApplicationController
        include TranslatableAttributes

        helper_method :superspaces, :superspace

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

        private

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
