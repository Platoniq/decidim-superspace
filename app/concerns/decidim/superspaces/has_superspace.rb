# frozen_string_literal: true

module Decidim
  module Superspaces
    module HasSuperspace
      extend ActiveSupport::Concern

      included do
        def superspace
          record = Decidim::Superspaces::SuperspacesParticipatorySpace.find_by(
            participatory_space_id: id,
            participatory_space_type: self.class.name
          )
          record.present? ? record.superspace : nil
        end
      end
    end
  end
end
