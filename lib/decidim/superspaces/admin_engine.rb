# frozen_string_literal: true

module Decidim
  module Superspaces
    # This is the engine that runs on the public interface of `Superspaces`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Superspaces::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :superspaces do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "superspaces#index"
      end

      def load_seed
        nil
      end
    end
  end
end
