# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe Superspaces do
    subject { described_class }

    it "has version" do
      expect(subject::VERSION).to eq("0.4.0")
    end

    it "has decidim version" do
      expect(subject::DECIDIM_VERSION).to eq("0.31.0")
    end

    it "has decidim compatible version" do
      expect(subject::COMPAT_DECIDIM_VERSION).to eq([">= 0.31.0", "< 0.32"])
    end
  end
end
