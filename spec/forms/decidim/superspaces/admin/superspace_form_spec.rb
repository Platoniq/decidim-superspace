# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Superspaces
    module Admin
      describe SuperspaceForm do
        subject do
          described_class.from_params(attributes).with_context(
            current_organization:
          )
        end

        let(:current_organization) { create(:organization) }

        let(:title) do
          {
            "en" => "Title",
            "ca" => "Títol",
            "es" => "Título"
          }
        end

        let(:locale){"en"}

        let(:hero_image){nil}

        let(:assembly_ids){[]}

        let(:participatory_process_ids){[]}

        let(:attributes) do
          {
            "superspace" => {
              "title" => title,
              "locale" => locale,
              "hero_image" => hero_image,
              "assembly_ids" => assembly_ids,
              "participatory_process_ids" => participatory_process_ids
            }
          }
        end

        context "when everything is OK" do
          it { is_expected.to be_valid }
        end

        context "when title is missing" do
          let(:title) do
            { "en" => "" }
          end

          it { is_expected.not_to be_valid }
        end

        context "when locale is missing" do
          let(:locale){""}

          it {is_expected.not_to be_valid}

        end
      end
    end
  end
end
