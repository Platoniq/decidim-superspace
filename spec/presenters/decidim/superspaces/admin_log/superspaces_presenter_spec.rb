# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Superspaces
    module AdminLog
      describe SuperspacePresenter, type: :helper do
        let(:admin_log_resource) { create(:superspace) }

        context "when action is create" do
          include_examples "present admin log entry" do
            let(:action) { "create" }
          end
        end

        context "when action is delete" do
          include_examples "present admin log entry" do
            let(:action) { "delete" }
          end
        end

        context "when action is update" do
          include_examples "present admin log entry" do
            let(:action) { "update" }
          end
        end

        context "when action is other" do
          include_examples "present admin log entry" do
            let(:action) { "other" }
          end
        end
      end
    end
  end
end
