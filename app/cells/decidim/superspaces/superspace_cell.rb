# frozen_string_literal: true

module Decidim
  module Superspaces
    # This cell renders the superspace card for an instance of a Superspace
    # the only size is the Grid Card (:g)
    class SuperspaceCell < Decidim::ViewModel
      def show
        cell card_size, model, options
      end

      private

      def card_size
        "decidim/superspaces/superspace_g"
      end
    end
  end
end
