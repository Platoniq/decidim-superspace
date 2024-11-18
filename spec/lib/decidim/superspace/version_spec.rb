# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe Superspace do
    subject { described_class }

    it "has version" do
      expect(subject.version).to eq("0.28.4")
    end
  end
end
