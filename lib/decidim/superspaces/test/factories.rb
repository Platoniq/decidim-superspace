# frozen_string_literal: true

FactoryBot.define do
  factory :superspace, class: "Decidim::Superspaces::Superspace" do
    transient do
      skip_injection { false }
    end

    title { generate_localized_title(:superspace_title, skip_injection:) }
    locale { Decidim.default_locale }
    organization
  end

  factory :superspaces_participatory_space, class: "Decidim::Superspaces::SuperspacesParticipatorySpace" do
    superspace factory: [:superspace]
    participatory_space { association(:participatory_process, :with_steps, organization: superspace.organization) }
  end
end
