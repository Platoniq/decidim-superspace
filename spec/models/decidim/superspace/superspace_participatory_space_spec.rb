# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Superspace
    describe SuperspaceParticipatorySpace do
      subject { build(:superspace_participatory_space) }

      it { is_expected.to be_valid }

      context "when the organization is different" do
        let(:organization) { create(:organization) }
        let(:other_organization) { create(:organization) }
        let(:superspace) { create(:superspace, organization:) }
        let(:participatory_space) { create(:participatory_process, organization: other_organization) }

        subject { build(:superspace_participatory_space, superspace:, participatory_space:) }

        it { is_expected.not_to be_valid }
      end

      context "when the participatory space is already associated with another superspace" do
        let(:superspace_participatory_space) { create(:superspace_participatory_space) }
        let(:participatory_space) { superspace_participatory_space.participatory_space }
        let(:superspace) { create(:superspace, organization: participatory_space.organization) }

        subject { build(:superspace_participatory_space, superspace:, participatory_space:) }

        it { is_expected.not_to be_valid }
      end
    end
  end
end
