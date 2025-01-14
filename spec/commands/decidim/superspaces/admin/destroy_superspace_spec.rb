# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Superspaces
    module Admin
      describe DestroySuperspace do
        subject { described_class.new(superspace, user) }

        let(:organization) { create(:organization) }
        let(:user) { create(:user, :admin, :confirmed, organization:) }
        let(:superspace) { create(:superspace, organization:) }

        it "destroys the superspace" do
          subject.call
          expect { superspace.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it "broadcasts ok" do
          expect do
            subject.call
          end.to broadcast(:ok)
        end

        it "traces the action", :versioning do
          expect(Decidim.traceability)
            .to receive(:perform_action!)
            .with("delete", superspace, user)
            .and_call_original

          expect { subject.call }.to change(Decidim::ActionLog, :count)
          action_log = Decidim::ActionLog.last
          expect(action_log.version).to be_present
        end
      end
    end
  end
end
