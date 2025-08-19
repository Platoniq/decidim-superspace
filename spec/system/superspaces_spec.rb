# frozen_string_literal: true

require "spec_helper"

describe "User sees superspaces" do
  let!(:organization) { create(:organization) }
  let!(:user) { create(:user, :admin, :confirmed, organization:) }
  let!(:superspaces) { create_list(:superspace, 10, organization:, content_blocks_order: ["assemblies", "participatory_processes", "conferences", "statistics"]) }
  let!(:assemblies) { create_list(:assembly, 10, organization:) }
  let!(:conferences) { create_list(:conference, 10, organization:) }
  let!(:participatory_processes) { create_list(:participatory_process, 10, organization:) }
  let!(:assembly) { assemblies.first }
  let!(:participatory_space) { participatory_processes.first }
  let!(:conference) { conferences.first }
  let!(:conference_superspace) { create(:superspaces_participatory_space, superspace: superspaces.first, participatory_space: conference) }
  let!(:assembly_superspace) { create(:superspaces_participatory_space, superspace: superspaces.first, participatory_space: assembly) }
  let!(:process_superspace) { create(:superspaces_participatory_space, superspace: superspaces.first, participatory_space:) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
  end

  context "when visiting superspaces path" do
    before do
      visit decidim_superspaces.root_path
    end

    it "renders the expected cards" do
      within all("#superspaces-grid").last do
        expect(page).to have_content(superspaces.first.title["en"])
      end
    end
  end

  context "when visiting superspace path" do
    before do
      visit decidim_superspaces.superspace_path(superspaces.first)
    end

    it "renders the expected grid if the superspace has content blocks" do
      within all("#participatory_processes-grid").last do
        expect(page).to have_content("Participatory Processes")
      end
      within all("#assemblies-grid").last do
        expect(page).to have_content("Assemblies")
      end
      within all("#statistics-grid").last do
        expect(page).to have_content("Statistics")
      end
    end
  end

  context "when visiting superspace with only active participatory space types" do
    let!(:superspace_with_only_assemblies) { create(:superspace, organization:, content_blocks_order: ["assemblies"]) }
    let!(:assembly) { create(:assembly, organization:) }
    let!(:participatory_process) { create(:participatory_process, organization:) }
    let!(:conference) { create(:conference, organization:) }
    let!(:assembly_superspace) { create(:superspaces_participatory_space, superspace: superspace_with_only_assemblies, participatory_space: assembly) }
    let!(:participatory_process_superspace) { create(:superspaces_participatory_space, superspace: superspace_with_only_assemblies, participatory_space: participatory_process) }
    let!(:conference_superspace) { create(:superspaces_participatory_space, superspace: superspace_with_only_assemblies, participatory_space: conference) }

    before do
      visit decidim_superspaces.superspace_path(superspace_with_only_assemblies)
    end

    it "only renders active participatory space types" do
      expect(page).to have_selector("#assemblies-grid")
      within "#assemblies-grid" do
        expect(page).to have_content("Assemblies")
      end

      expect(page).to have_no_selector("#participatory_processes-grid")
      expect(page).to have_no_selector("#conferences-grid")
      expect(page).to have_no_selector("#statistics-grid")
    end
  end

  context "when visiting superspace with custom order of active types" do
    let!(:superspace_custom_order) { create(:superspace, organization:, content_blocks_order: ["conferences", "assemblies"]) }
    let!(:assembly) { create(:assembly, organization:) }
    let!(:participatory_process) { create(:participatory_process, organization:) }
    let!(:conference) { create(:conference, organization:) }
    let!(:assembly_superspace) { create(:superspaces_participatory_space, superspace: superspace_custom_order, participatory_space: assembly) }
    let!(:participatory_process_superspace) { create(:superspaces_participatory_space, superspace: superspace_custom_order, participatory_space: participatory_process) }
    let!(:conference_superspace) { create(:superspaces_participatory_space, superspace: superspace_custom_order, participatory_space: conference) }

    before do
      visit decidim_superspaces.superspace_path(superspace_custom_order)
    end

    it "renders active participatory space types in the specified order" do
      expect(page).to have_selector("#conferences-grid")
      expect(page).to have_selector("#assemblies-grid")
      expect(page).to have_no_selector("#participatory_processes-grid")

      conferences_position = page.body.index('id="conferences-grid"')
      assemblies_position = page.body.index('id="assemblies-grid"')

      expect(conferences_position).to be < assemblies_position
    end
  end

  context "when visiting superspace with no active content block types" do
    let!(:superspace_no_active) { create(:superspace, organization:, content_blocks_order: []) }
    let!(:assembly) { create(:assembly, organization:) }
    let!(:participatory_process) { create(:participatory_process, organization:) }
    let!(:conference) { create(:conference, organization:) }
    let!(:assembly_superspace) { create(:superspaces_participatory_space, superspace: superspace_no_active, participatory_space: assembly) }
    let!(:participatory_process_superspace) { create(:superspaces_participatory_space, superspace: superspace_no_active, participatory_space: participatory_process) }
    let!(:conference_superspace) { create(:superspaces_participatory_space, superspace: superspace_no_active, participatory_space: conference) }

    before do
      visit decidim_superspaces.superspace_path(superspace_no_active)
    end

    it "shows no content block grids but shows empty message" do
      expect(page).to have_no_selector("#assemblies-grid")
      expect(page).to have_no_selector("#participatory_processes-grid")
      expect(page).to have_no_selector("#conferences-grid")
      expect(page).to have_content("There are no active content blocks")
      expect(page).to have_no_selector("#statistics-grid")
    end
  end

  context "when visiting empty superspace path" do
    before do
      visit decidim_superspaces.superspace_path(superspaces.last)
    end

    it "doesn't render grid if the superspace is empty" do
      expect(page).to have_no_selector("#processes-grid")
      expect(page).to have_no_selector("#assemblies-grid")
      expect(page).to have_css("#statistics-grid")
    end
  end

  context "when visiting assembly path" do
    before do
      visit decidim_assemblies.assembly_path(assembly)
    end

    it "renders the superspace reference" do
      expect(page).to have_content("This space is part of the #{superspaces.first.title["en"]} superspace.")
    end
  end

  context "when visiting participatory process path" do
    before do
      visit decidim_participatory_processes.participatory_process_path(participatory_space)
    end

    it "renders the superspace reference" do
      expect(page).to have_content("This space is part of the #{superspaces.first.title["en"]} superspace.")
    end
  end

  context "when visiting conference path" do
    before do
      visit decidim_conferences.conference_path(conference)
    end

    it "renders the superspace reference" do
      expect(page).to have_content("This space is part of the #{superspaces.first.title["en"]} superspace.")
    end
  end
end
