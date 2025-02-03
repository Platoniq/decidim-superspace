# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Superspaces
    describe SuperspacesController do
      routes { Decidim::Superspaces::SuperspacesController._routes }

      let(:organization) { create(:organization) }
      let(:user) { create(:user, :admin, :confirmed, organization:) }
      let!(:superspaces) { create_list(:superspace, 10, organization:) }
      let!(:assemblies) { create_list(:assembly, 10, organization:) }
      let!(:participatory_processes) { create_list(:participatory_process, 10, organization:) }
      let(:participatory_space) { participatory_processes.first }

      subject { build(:superspaces_participatory_space, superspace: superspace.first, participatory_space:) }

      before do
        request.env["decidim.current_organization"] = organization
        sign_in user, scope: :user
      end

      describe "#index" do
        it "renders the index template" do
          get :index

          expect(response).to render_template(:index)
        end
      end

      describe "#show" do
        it "renders the show template" do
          get :show, params: { id: superspaces.first.id }

          expect(response).to render_template(:show)
        end
      end
    end
  end
end
