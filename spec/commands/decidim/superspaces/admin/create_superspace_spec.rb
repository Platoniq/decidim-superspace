# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Superspaces
    module Admin
      describe CreateSuperspace do
        subject { described_class.new(form, current_user) }

        let(:organization) { create(:organization) }
        let(:current_user) { create(:user, organization:) }
        let(:title) { "Superspace title" }
        let(:description) { "Superspace description" }
        let(:locale) { "en" }
        let(:hero_image) { nil }
        let(:assembly_ids) { nil }
        let(:participatory_process_ids) { nil }
        let(:conference_ids) { nil }
        let(:invalid) { false }
        let(:show_statistics) { false }
        let(:form) do
          double(
            invalid?: invalid,
            title: { en: title },
            description: { en: description },
            current_organization: organization,
            hero_image:,
            locale:,
            assembly_ids:,
            participatory_process_ids:,
            conference_ids:,
            show_statistics:
          )
        end

        context "when the form is not valid" do
          let(:invalid) { true }

          it "is not valid" do
            expect { subject.call }.to broadcast(:invalid)
          end
        end

        context "when everything is ok" do
          let(:superspace) { Superspace.last }

          it "creates the superspace" do
            expect { subject.call }.to change(Superspace, :count).by(1)
          end

          it "sets the title" do
            subject.call
            expect(translated(superspace.title)).to eq title
          end

          it "broadcasts ok" do
            expect { subject.call }.to broadcast(:ok)
          end

          it "traces the action", :versioning do
            expect(Decidim.traceability)
              .to receive(:create!)
              .with(Superspace, current_user, kind_of(Hash))
              .and_call_original

            expect { subject.call }.to change(Decidim::ActionLog, :count)

            expect(Decidim::ActionLog.last.resource).to eq superspace
          end
        end
      end
    end
  end
end
