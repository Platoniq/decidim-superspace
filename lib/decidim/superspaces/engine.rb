# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module Superspaces
    # This is the engine that runs on the public interface of superspaces.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Superspaces

      routes do
        # Add engine routes here
        # resources :superspaces
        # root to: "superspaces#index"
      end

      initializer "decidim_superspaces.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
