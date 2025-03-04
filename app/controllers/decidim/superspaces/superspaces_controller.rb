# frozen_string_literal: true

module Decidim
  module Superspaces
    class SuperspacesController < ApplicationController
      include HasSpecificBreadcrumb

      helper_method :collection, :superspace

      def index
        enforce_permission_to :list, :superspace
      end

      def show
        enforce_permission_to :read, :superspace, superspace:
      end

      private

      def superspace
        @superspace ||= filtered_superspaces.find(params[:id])
      end

      def collection
        @superspaces ||= filtered_superspaces
      end

      def filtered_superspaces
        Superspace.where(organization: current_organization)
      end

      def breadcrumb_item
        {
          label: t("decidim.superspaces.superspaces.index.title"),
          active: true,
          url: superspaces_path
        }
      end
    end
  end
end
