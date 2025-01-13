# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Superspaces
    module Admin
      describe UpdateSuperspace do
        subject { described_class.new(form, superspace, current_user) }

        let(:organization) { create(:organization) }
        let(:current_user) { create(:user, organization:) }
        let(:title) { "Superspace title" }
        let(:superspace) { create(:superspace, organization:) }
        let(:invalid) { false }
        let(:locale) { "en" }
        let(:hero_image) { nil }
        let(:assembly_ids) { nil }
        let(:participatory_process_ids) { nil }
        let(:form) do
          double(
            invalid?: invalid,
            title: { en: title },
            current_organization: organization,
            hero_image:,
            locale:,
            assembly_ids:,
            participatory_process_ids:
          )
        end

        context "when the form is not valid" do
          let(:invalid) { true }

          it "is not valid" do
            expect { subject.call }.to broadcast(:invalid)
          end

          it "doesn't update the superspace" do
            expect(superspace).not_to receive(:update!)
            subject.call
          end
        end

        context "when everything is ok" do
          let(:title) { "Superspace title updated" }
          let(:locale) { "fr" }

          it "updates the title" do
            subject.call
            expect(translated(superspace.title)).to eq title
          end

          it "updates the locale" do
            subject.call
            expect(superspace.locale).to eq locale
          end

          it "broadcasts ok" do
            expect { subject.call }.to broadcast(:ok)
          end

          it "traces the action", :versioning do
            expect(Decidim.traceability)
              .to receive(:update!)
              .with(superspace, current_user, { title: { en: title }, locale:, hero_image: })
              .and_call_original

            expect { subject.call }.to change(Decidim::ActionLog, :count)

            expect(Decidim::ActionLog.last.resource).to eq superspace
          end
        end
      end
    end
  end
end
