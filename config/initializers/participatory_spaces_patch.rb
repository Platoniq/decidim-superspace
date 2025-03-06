Rails.application.config.to_prepare do
    Decidim::Assembly.class_eval do
      def superspace
        record = Decidim::Superspaces::SuperspacesParticipatorySpace.find_by(
          participatory_space_id: self.id, 
          participatory_space_type: self.class.name
        )
        record.present? ? record.superspace : nil
      end
    end

    Decidim::ParticipatoryProcess.class_eval do
        def superspace
          record = Decidim::Superspaces::SuperspacesParticipatorySpace.find_by(
            participatory_space_id: self.id, 
            participatory_space_type: self.class.name
          )
          record.present? ? record.superspace : nil
        end
    end

    Decidim::Conference.class_eval do
        def superspace
          record = Decidim::Superspaces::SuperspacesParticipatorySpace.find_by(
            participatory_space_id: self.id, 
            participatory_space_type: self.class.name
          )
          record.present? ? record.superspace : nil
        end
    end
end