# frozen_string_literal: true

require "spec_helper"

describe "User sees superspaces" do
  let!(:organization) { create(:organization) }
  let!(:user) { create(:user, :admin, :confirmed, organization:) }
  let!(:superspaces) { create_list(:superspace, 10, organization:, show_statistics: true) }
  let!(:assemblies) { create_list(:assembly, 10, organization:) }
  let!(:participatory_processes) { create_list(:participatory_process, 10, organization:) }
  let!(:assembly) { assemblies.first }
  let!(:participatory_space) { participatory_processes.first }
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

    it "renders the expected grid if the superspace has participatory spaces" do
      within all("#processes-grid").last do
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

  context "when visiting empty superspace path" do
    before do
      visit decidim_superspaces.superspace_path(superspaces.last)
    end

    it "doesn't render grid if the superspace is empty" do
      expect(page).to have_no_selector("#processes-grid")
      expect(page).to have_no_selector("#assemblies-grid")
      expect(page).to have_css("#statistics-grid")
    end

    it "doesn't render statistics if the superspace show statistics is false" do
      superspaces.last.update!(show_statistics: false)
      visit decidim_superspaces.superspace_path(superspaces.last)

      expect(page).to have_no_selector("#statistics-grid")
    end
  end
end
