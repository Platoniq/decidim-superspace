# frozen_string_literal: true

module Decidim
  module Superspaces
    class SuperspacesController < ApplicationController
      helper_method :superspaces, :superspace

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

      def superspaces
        @superspaces ||= filtered_superspaces
      end

      def filtered_superspaces
        Superspace.where(organization: current_organization)
      end
    end
  end
end
