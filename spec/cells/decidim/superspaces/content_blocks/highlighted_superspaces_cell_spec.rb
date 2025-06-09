# frozen_string_literal: true

require "spec_helper"

describe Decidim::Superspaces::ContentBlocks::HighlightedSuperspacesCell, type: :cell do
  subject { cell(content_block.cell, content_block).call }

  let(:organization) { create(:organization) }
  let(:content_block) { create(:content_block, organization:, manifest_name: :highlighted_superspaces, scope_name: :homepage, settings:) }
  let!(:superspaces) { create_list(:superspace, 8, organization:) }
  let(:settings) { {} }

  let(:highlighted_superspaces) { subject.find(id: "highlighted-superspaces") }

  controller Decidim::PagesController

  before do
    allow(controller).to receive(:current_organization).and_return(organization)
  end

  context "when the content block has no settings" do
    it "shows 6 superspaces" do
      expect(highlighted_superspaces).to have_css("a.card__grid", count: 6)
    end
  end

  context "when the content block has customized the max results setting value" do
    let(:settings) do
      {
        "max_results" => "9"
      }
    end

    it "shows up to 8 superspaces" do
      expect(highlighted_superspaces).to have_css("a.card__grid", count: 8)
    end
  end
end
