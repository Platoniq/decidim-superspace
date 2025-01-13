# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Superspaces
    module Admin
      describe SuperspacesController do
        routes { Decidim::Superspaces::AdminEngine.routes }

        let(:organization) { create(:organization) }
        let(:user) { create(:user, :admin, :confirmed, organization:) }
        let!(:superspaces) { create_list(:superspace, 10, organization:) }

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

        describe "#new" do
          it "renders the new template" do
            get :new

            expect(response).to render_template(:new)
          end
        end

        describe "#edit" do
          let(:params) do
            {
              id:
            }
          end

          context "with valid params" do
            let(:id) { superspaces.first.id }

            it "renders the edit template" do
              get(:edit, params:)

              expect(response).to render_template(:edit)
            end
          end

          context "with non existing record" do
            let(:id) { -1 }

            it "raise not found exception" do
              expect { get :edit, params: }.to raise_error(ActiveRecord::RecordNotFound)
            end
          end
        end

        describe "#create" do
          let(:params) do
            {
              title: {
                en: title
              },
              locale: locale

              
            }
          end

          context "with invalid params" do
            let(:title) { "" }
            let(:locale){""}
           


            it "renders the new template" do
              post(:create, params:)

              expect(response).to render_template(:new)
            end
          end

          context "with valid params" do
            let(:title) { "My title" }
            let(:locale){"en"}
            

            it "redirects to index" do
              expect(controller).to receive(:redirect_to) do |params|
                expect(params).to eq("/superspaces")
              end

              post :create, params:
            end
          end
        end

        describe "#update" do
          let(:params) do
            {
              id:,
              title: {
                en: title
              },
              locale: locale
            }
          end

          context "with existing record" do
            let(:id) { superspaces.first.id }

            context "with invalid params" do
              let(:title) { "" }
              let(:locale) {""}

              it "renders the edit template" do
                put(:update, params:)

                expect(response).to render_template(:edit)
              end
            end

            context "with valid params" do
              let(:title) { "My title" }
              let(:locale) {"fr"}

              it "redirects to index" do
                expect(controller).to receive(:redirect_to) do |params|
                  expect(params).to eq("/superspaces")
                end

                put :update, params:
              end
            end
          end

          context "with non existing record" do
            let(:id) { -1 }
            let(:title) { "My title" }
            let(:locale) {"en"}

            it "raise not found exception" do
              expect { put :update, params: }.to raise_error(ActiveRecord::RecordNotFound)
            end
          end
        end

        describe "#destroy" do
          let(:params) do
            {
              id:
            }
          end

          context "with existing record" do
            let(:id) { superspaces.first.id }

            it "redirects to index" do
              expect(controller).to receive(:redirect_to) do |params|
                expect(params).to eq("/superspaces")
              end

              delete :destroy, params:
            end
          end

          context "with non existing record" do
            let(:id) { -1 }

            it "raise not found exception" do
              expect { delete :destroy, params: }.to raise_error(ActiveRecord::RecordNotFound)
            end
          end
        end
      end
    end
  end
end
