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

  def visit_configure_superspace_path(superspace)
    visit decidim_admin_superspaces.configure_superspace_path(superspace)
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
      let!(:assemblies) { create_list(:assembly, 2, organization:) }
      let!(:participatory_processes) { create_list(:participatory_process, 2, organization:) }
      let(:superspace) { superspaces.first }
      let(:assembly) { assemblies.first }
      let(:participatory_process) { participatory_processes.first }

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

        select "English", from: "superspace_locale"

        check "superspace_assembly_ids_#{assembly.id}"

        check "superspace_participatory_process_ids_#{participatory_process.id}"

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

        select "English", from: "superspace_locale"

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

  context "when configuring superspace participatory spaces order" do
    let!(:superspace) { create(:superspace, organization:) }
    let!(:assemblies) { create_list(:assembly, 2, organization:) }
    let!(:participatory_processes) { create_list(:participatory_process, 2, organization:) }
    let!(:conferences) { create_list(:conference, 2, organization:) }

    before do
      # Link participatory spaces to the superspace
      assemblies.each { |assembly| create(:superspaces_participatory_space, superspace:, participatory_space: assembly) }
      participatory_processes.each { |process| create(:superspaces_participatory_space, superspace:, participatory_space: process) }
      conferences.each { |conference| create(:superspaces_participatory_space, superspace:, participatory_space: conference) }
    end

    context "when visiting configure page" do
      before do
        visit_superspaces_path
        within "tr", text: translated(superspace.title) do
          click_on "Configure"
        end
      end

      it "shows the configure page with drag and drop interface" do
        expect(page).to have_content("Participatory Spaces Order")
        expect(page).to have_content("Active Participatory Spaces")
        expect(page).to have_content("Inactive Participatory Spaces")
        expect(page).to have_selector(".draggable-list.js-list-actives")
        expect(page).to have_selector(".draggable-list.js-list-available")
      end

      it "shows all participatory space types in inactive list initially" do
        within ".js-list-available" do
          expect(page).to have_content("Assemblies")
          expect(page).to have_content("Participatory processes")
          expect(page).to have_content("Conferences")
        end

        within ".js-list-actives" do
          expect(page).to have_no_content("Assemblies")
          expect(page).to have_no_content("Participatory processes")
          expect(page).to have_no_content("Conferences")
        end
      end

      it "shows correct counts for each participatory space type" do
        within ".js-list-available" do
          expect(page).to have_content("2 Assemblies")
          expect(page).to have_content("2 Participatory processes")
          expect(page).to have_content("2 Conferences")
        end
      end

      it "shows draggable elements with correct attributes" do
        expect(page).to have_selector('li[draggable="true"][data-content-block-id="assemblies"]')
        expect(page).to have_selector('li[draggable="true"][data-content-block-id="participatory_processes"]')
        expect(page).to have_selector('li[draggable="true"][data-content-block-id="conferences"]')
      end

      it "has the correct AJAX endpoint for updating order" do
        active_list = find(".js-list-actives")
        expect(active_list["data-sort-url"]).to include("update_spaces_order")
      end
    end

    context "when superspace has some active participatory space types" do
      before do
        superspace.update!(participatory_spaces_order: ["assemblies", "conferences"])
        visit_configure_superspace_path(superspace)
      end

      it "shows active types in the active list and inactive in the inactive list" do
        within ".js-list-actives" do
          expect(page).to have_content("Assemblies")
          expect(page).to have_content("Conferences")
          expect(page).to have_no_content("Participatory processes")
        end

        within ".js-list-available" do
          expect(page).to have_content("Participatory processes")
          expect(page).to have_no_content("Assemblies")
          expect(page).to have_no_content("Conferences")
        end
      end

      it "shows active types in the correct order" do
        active_items = all(".js-list-actives li")
        expect(active_items[0]).to have_content("Assemblies")
        expect(active_items[1]).to have_content("Conferences")
      end
    end

    context "when superspace has all participatory space types active" do
      before do
        superspace.update!(participatory_spaces_order: ["participatory_processes", "assemblies", "conferences"])
        visit_configure_superspace_path(superspace)
      end

      it "shows all types in the active list and none in inactive" do
        within ".js-list-actives" do
          expect(page).to have_content("Assemblies")
          expect(page).to have_content("Participatory processes")
          expect(page).to have_content("Conferences")
        end

        within ".js-list-available" do
          expect(page).to have_no_content("Assemblies")
          expect(page).to have_no_content("Participatory processes")
          expect(page).to have_no_content("Conferences")
        end
      end

      it "shows no items for empty states" do
        within ".js-list-available" do
          expect(page).to have_no_selector("li")
        end
      end
    end

    context "when superspace has no participatory spaces" do
      let!(:empty_superspace) { create(:superspace, organization:) }

      before do
        visit_configure_superspace_path(empty_superspace)
      end

      it "shows empty lists when superspace has no participatory spaces" do
        within ".js-list-actives" do
          expect(page).to have_no_selector("li")
        end

        within ".js-list-available" do
          expect(page).to have_no_selector("li")
        end
      end
    end

    context "when updating participatory spaces order via drag and drop", js: true do
      before do
        superspace.update!(participatory_spaces_order: ["assemblies"])
        visit_configure_superspace_path(superspace)
      end

      it "updates the order when elements are dragged and dropped" do
        # Check initial state
        expect(superspace.participatory_spaces_order).to eq(["assemblies"])

        # Simulate drag and drop by moving elements between lists
        page.execute_script(<<~JS)
          var sourceElement = document.querySelector('.js-list-available li[data-content-block-id="participatory_processes"]');
          var targetList = document.querySelector('.js-list-actives');

          if (sourceElement && targetList) {
            targetList.appendChild(sourceElement);

            var event = new Event('dragend', { bubbles: true });
            sourceElement.dispatchEvent(event);
          }
        JS

        # Wait for the AJAX request to complete
        sleep(1)

        # Check that the order was updated in the database
        superspace.reload
        expect(superspace.participatory_spaces_order).to include("participatory_processes")
        expect(superspace.participatory_spaces_order).to include("assemblies")
      end

      it "allows reordering active elements by dragging" do
        # Set up with multiple active elements
        superspace.update!(participatory_spaces_order: ["assemblies", "conferences", "participatory_processes"])
        visit_configure_superspace_path(superspace)

        # Check initial order
        active_items = all(".js-list-actives li")
        expect(active_items[0]).to have_content("Assemblies")
        expect(active_items[1]).to have_content("Conferences")
        expect(active_items[2]).to have_content("Participatory processes")

        # Simulate reordering: move "conferences" to the end
        page.execute_script(<<~JS)
          var activeList = document.querySelector('.js-list-actives');
          var conferenceElement = document.querySelector('.js-list-actives li[data-content-block-id="conferences"]');
          var processElement = document.querySelector('.js-list-actives li[data-content-block-id="participatory_processes"]');

          if (activeList && conferenceElement && processElement) {
            // Move conferences after participatory_processes
            activeList.insertBefore(conferenceElement, processElement.nextSibling);

            // Trigger dragend event
            var event = new Event('dragend', { bubbles: true });
            conferenceElement.dispatchEvent(event);
          }
        JS

        # Wait for AJAX request to complete
        sleep(1)

        # Verify the order was updated
        superspace.reload
        expected_order = ["assemblies", "participatory_processes", "conferences"]
        expect(superspace.participatory_spaces_order).to eq(expected_order)
      end

      it "removes elements from active list when dragged to inactive" do
        # Configure the initial state with active elements
        superspace.update!(participatory_spaces_order: ["assemblies", "conferences"])
        visit_configure_superspace_path(superspace)

        # Simulate dragging "conferences" to the inactive list
        page.execute_script(<<~JS)
          var conferenceElement = document.querySelector('.js-list-actives li[data-content-block-id="conferences"]');
          var inactiveList = document.querySelector('.js-list-available');

          if (conferenceElement && inactiveList) {
            // Move the element
            inactiveList.appendChild(conferenceElement);

            // Trigger dragend event
            var event = new Event('dragend', { bubbles: true });
            conferenceElement.dispatchEvent(event);
          }
        JS

        # Wait for AJAX request to complete
        sleep(1)

        # Verify that only "assemblies" remains active
        superspace.reload
        expect(superspace.participatory_spaces_order).to eq(["assemblies"])
        expect(superspace.participatory_spaces_order).not_to include("conferences")
      end

      it "handles empty active list correctly" do
        # Start with one active element
        superspace.update!(participatory_spaces_order: ["assemblies"])
        visit_configure_superspace_path(superspace)

        # Move the only active element to inactive
        page.execute_script(<<~JS)
          var assemblyElement = document.querySelector('.js-list-actives li[data-content-block-id="assemblies"]');
          var inactiveList = document.querySelector('.js-list-available');

          if (assemblyElement && inactiveList) {
            inactiveList.appendChild(assemblyElement);

            var event = new Event('dragend', { bubbles: true });
            assemblyElement.dispatchEvent(event);
          }
        JS

        # Wait for AJAX request to complete
        sleep(1)

        # Verify that there are no active elements
        superspace.reload
        expect(superspace.participatory_spaces_order).to eq([])
      end
    end
  end
end
