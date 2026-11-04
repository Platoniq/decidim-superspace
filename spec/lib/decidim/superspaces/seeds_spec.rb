# frozen_string_literal: true

require "spec_helper"
require "decidim/superspaces/seeds"

module Decidim
  module Superspaces
    describe Seeds do
      subject { described_class.new.call }

      let!(:organization) { create(:organization) }
      let!(:admin) { create(:user, :admin, :confirmed, organization:, email: "admin@example.org") }
      let!(:assemblies) { create_list(:assembly, 2, organization:) }
      let!(:participatory_process) { create(:participatory_process, organization:) }
      let!(:conference) { create(:conference, organization:) }

      it "creates at least two superspaces" do
        expect { subject }.to change(Superspace, :count).by(2)
      end

      it "links every participatory space to a superspace" do
        subject

        expect(SuperspacesParticipatorySpace.pluck(:participatory_space_type, :participatory_space_id)).to contain_exactly(
          *assemblies.map { |assembly| ["Decidim::Assembly", assembly.id] },
          ["Decidim::ParticipatoryProcess", participatory_process.id],
          ["Decidim::Conference", conference.id]
        )
        expect(Superspace.all).to all(satisfy { |superspace| superspace.participatory_spaces.any? })
      end

      it "shows the linked space types and statistics" do
        subject

        Superspace.find_each do |superspace|
          expect(superspace.content_blocks_order.last).to eq("statistics")
          expect(superspace.content_blocks_order).to include("assemblies")
        end
      end
    end
  end
end
