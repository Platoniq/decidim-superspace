# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Superspaces
    describe Permissions do
      subject { described_class.new(user, permission_action, context).permissions.allowed? }

      let(:user) { create(:user, :admin, organization:) }
      let(:organization) { create(:organization) }
      let(:superspace) { create(:superspace, organization:) }
      let(:permission_action) { Decidim::PermissionAction.new(**action) }

      context "with superspace as scope" do
        let(:context) do
          {
            superspace:
          }
        end

        context "when scope is public" do
          let(:action) do
            { scope: :public, action: :list, subject: :superspace }
          end

          it { is_expected.to be true }
        end

        context "when scope is public and action is not allowed" do
          let(:action) do
            { scope: :public, action: :edit, subject: :superspace }
          end

          it { is_expected.to be false }
        end

        context "when no user" do
          let(:user) { nil }

          let(:action) do
            { scope: :public, action: :list, subject: :superspace }
          end

          it_behaves_like "permission is not set"
        end

        context "when subject is a random one" do
          let(:action) do
            { scope: :admin, action: :list, subject: :foo }
          end

          it_behaves_like "permission is not set"
        end
      end
    end
  end
end
