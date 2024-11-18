# frozen_string_literal: true

module Decidim
  module Superspace
    # This is the engine that runs on the public interface of `Superspace`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Superspace::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :superspace do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "superspace#index"
      end

      def load_seed
        nil
      end
    end
  end
end
