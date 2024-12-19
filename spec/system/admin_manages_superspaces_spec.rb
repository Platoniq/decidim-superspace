# frozen_string_literal: true

require "spec_helper"

describe "Admin manages superspaces" do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :admin, :confirmed, organization:) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_admin.root_path
  end

  def visit_superspaces_path
    visit decidim_admin_superspaces.superspaces_path
  end

  def visit_edit_superspace_path(superspace)
    visit decidim_admin_superspaces.edit_superspace_path(superspace)
  end

  it "renders the expected menu" do
    within all(".main-nav").last do
      expect(page).to have_content("Superspaces")
    end

    click_on "Superspaces"

    within ".process-title" do
      expect(page).to have_content("Superspaces")
    end
  end

  context "when visiting superspaces path" do
    before do
      visit_superspaces_path
    end

    it "shows new superspace button" do
      expect(page).to have_content("New superspace")
    end

    context "when no superspaces created" do
      it "shows an empty table" do
        expect(page).to have_no_selector("table.table-list.superspaces tbody tr")
      end
    end

    context "when superspaces created" do
      let!(:superspaces) { create_list(:superspace, 5, organization:) }
      let(:superspace) { superspaces.first }

      before do
        visit_superspaces_path
      end

      it "shows table rows" do
        expect(page).to have_css("table.table-list.superspaces tbody tr", count: 5)
      end

      it "shows all the superspaces" do
        superspaces.each do |superspace|
          expect(page).to have_content(translated(superspace.title))
        end
      end

      it "can create superspace and show the action in the admin log" do
        find(".card .item_show__header-title a.button.new").click

        fill_in_i18n(
          :superspace_title,
          "#superspace-title-tabs",
          en: "My superspace"
        )

        within ".new_superspace" do
          find("*[type=submit]").click
        end

        expect(page).to have_admin_callout("successfully")

        within "table" do
          expect(page).to have_content("My superspace")
        end

        click_on "Admin activity log"

        expect(page).to have_content("created the My superspace superspace")
      end

      it "cannot create an invalid superspace" do
        find(".card .item_show__header-title a.button.new").click

        within ".new_superspace" do
          find("*[type=submit]").click
        end

        expect(page).to have_admin_callout("problem")
      end

      it "can edit superspace and show the action in the admin log" do
        within "tr", text: translated(superspace.title) do
          click_on "Edit"
        end

        fill_in_i18n(
          :superspace_title,
          "#superspace-title-tabs",
          en: "My edited superspace"
        )

        within ".edit_superspace" do
          find("*[type=submit]").click
        end

        expect(page).to have_admin_callout("successfully")
        expect(page).to have_content("My edited superspace")

        click_on "Admin activity log"

        expect(page).to have_content("updated the My edited superspace superspace")
      end

      it "cannot save an edited invalid superspace" do
        within "tr", text: translated(superspace.title) do
          click_on "Edit"
        end

        fill_in_i18n(
          :superspace_title,
          "#superspace-title-tabs",
          en: ""
        )

        within ".edit_superspace" do
          find("*[type=submit]").click
        end

        expect(page).to have_admin_callout("problem")
      end

      it "can delete superspace" do
        within "tr", text: translated(superspace.title) do
          accept_confirm { click_on "Delete" }
        end

        expect(page).to have_admin_callout("successfully")

        within "table" do
          expect(page).to have_no_content(translated(superspace.title))
          expect(page).to have_css("table.table-list.superspaces tbody tr", count: 4)
        end
      end

      context "when superspace from other organization" do
        let(:other_organization) { create(:organization) }
        let!(:superspace) { create(:superspace, organization: other_organization) }

        it "does not show the it" do
          visit_superspaces_path

          expect(page).to have_no_content(translated(superspace.title))
        end
      end
    end
  end
end
