# frozen_string_literal: true

require "rails"
require "decidim/core"

require_relative "content_blocks/content_blocks_homepage"

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
        Decidim::Assembly.include(Decidim::Superspaces::HasSuperspace)
        Decidim::ParticipatoryProcess.include(Decidim::Superspaces::HasSuperspace)
        Decidim::Conference.include(Decidim::Superspaces::HasSuperspace)
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

      initializer "decidim_superspaces.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Superspaces::Engine.root}/app/cells")
      end

      initialize_homepage_content_blocks
    end
  end
end
