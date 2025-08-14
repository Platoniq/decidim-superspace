# frozen_string_literal: true

module Decidim
  module Superspaces
    # This is the engine that runs on the public interface of `Superspaces`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Superspaces::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        resources :superspaces do
          member do
            get :configure
            put :update_spaces_order
          end
        end
        root to: "superspaces#index"
      end

      initializer "decidim_superspaces.admin_mount_routes" do
        Decidim::Core::Engine.routes do
          mount Decidim::Superspaces::AdminEngine, at: "/admin/superspaces", as: "decidim_admin_superspaces"
        end
      end

      initializer "decidim_superspaces.admin_menu" do
        Decidim.menu :admin_menu do |menu|
          menu.add_item :superspaces,
                        I18n.t("menu.superspaces", scope: "decidim.admin", default: "Superspaces"),
                        decidim_admin_superspaces.superspaces_path,
                        icon_name: "global-line",
                        position: 1,
                        active: :inclusive
        end
      end

      def load_seed
        nil
      end
    end
  end
end
