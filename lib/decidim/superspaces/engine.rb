# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module Superspaces
    # This is the engine that runs on the public interface of superspaces.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Superspaces

      routes do
        resources :superspaces
        root to: "superspaces#index"
      end

      config.to_prepare do
        Decidim::Assembly.include(Decidim::Superspaces::CheckSuperspace)
        Decidim::ParticipatoryProcess.include(Decidim::Superspaces::CheckSuperspace)
        Decidim::Conference.include(Decidim::Superspaces::CheckSuperspace)
      end

      initializer "decidim_superspaces.register_resources" do
        Decidim.register_resource(:superspace) do |resource|
          resource.model_class_name = "Decidim::Superspaces::Superspace"
          resource.card = "decidim/superspaces/superspace"
        end
      end

      initializer "decidim_superspaces.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
