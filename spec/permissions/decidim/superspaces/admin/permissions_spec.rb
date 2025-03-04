# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Superspaces
    module Admin
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

          context "when scope is admin" do
            let(:action) do
              { scope: :admin, action: :foo, subject: :superspace }
            end

            it { is_expected.to be true }
          end

          context "when no user" do
            let(:user) { nil }

            let(:action) do
              { scope: :admin, action: :foo, subject: :superspace }
            end

            it_behaves_like "permission is not set"
          end

          context "when user is not admin" do
            let(:user) { create(:user, organization: superspace.organization) }

            let(:action) do
              { scope: :admin, action: :foo, subject: :superspace }
            end

            it_behaves_like "permission is not set"
          end

          context "when scope is a random one" do
            let(:action) do
              { scope: :foo, action: :foo, subject: :superspace }
            end

            it_behaves_like "permission is not set"
          end

          context "when subject is a random one" do
            let(:action) do
              { scope: :admin, action: :foo, subject: :foo }
            end

            it_behaves_like "permission is not set"
          end
        end
      end
    end
  end
end
