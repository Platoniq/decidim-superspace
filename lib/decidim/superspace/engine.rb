# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module Superspace
    # This is the engine that runs on the public interface of superspace.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Superspace

      routes do
        # Add engine routes here
        # resources :superspace
        # root to: "superspace#index"
      end

      initializer "Superspace.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
