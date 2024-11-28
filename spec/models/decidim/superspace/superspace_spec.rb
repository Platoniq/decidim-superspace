# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Superspace
    describe Superspace do
      subject { build(:superspace) }

      it { is_expected.to be_valid }
    end
  end
end
