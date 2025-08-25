# frozen_string_literal: true

module Decidim
  module Superspaces
    module Admin
      # This cell renders a participatory space type block for the superspace configuration
      class ParticipatorySpaceTypeCell < Decidim::ViewModel
        def show
          render
        end

        private

        def type_name
          model[:type]
        end

        def type_count
          model[:count]
        end

        def type_title
          if statistics?
            t("decidim.superspaces.admin.superspaces.configure.#{type_name}")
          else
            t("decidim.superspaces.admin.superspaces.configure.#{type_name.singularize}").pluralize
          end
        end

        def type_description
          return nil if statistics?

          "#{type_count} #{t("decidim.superspaces.admin.superspaces.configure.#{type_name.singularize}").pluralize(type_count)}"
        end

        def show_description?
          !statistics?
        end

        def statistics?
          type_name == "statistics"
        end
      end
    end
  end
end
