# frozen_string_literal: true

require "i18n/tasks"

describe "I18n sanity" do
  let(:locales) do
    ENV["ENFORCED_LOCALES"].presence || "en"
  end

  let(:i18n) { I18n::Tasks::BaseTask.new(locales: locales.split(",")) }
  let(:missing_keys) { i18n.missing_keys }
  let(:unused_keys) { i18n.unused_keys }
  let(:non_normalized_paths) { i18n.non_normalized_paths }

  it "does not have missing keys" do
    expect(missing_keys).to be_empty, "#{missing_keys.inspect} are missing"
  end

  it "does not have unused keys" do
    unused_keys_hash = unused_keys.to_hash

    locales.split(",").each do |locale|
      unused_keys_hash[locale]&.fetch("activemodel", nil)&.fetch("attributes", nil)&.fetch("superspace", nil)&.delete("hero_image")
    end

    def deep_reject_empty!(hash)
      hash.each do |_k, v|
        deep_reject_empty!(v) if v.is_a?(Hash)
      end
      hash.reject! { |_k, v| v.is_a?(Hash) && v.empty? }
    end

    deep_reject_empty!(unused_keys_hash)

    expect(unused_keys_hash).to be_empty, "#{unused_keys_hash.inspect} are unused"
  end

  unless ENV["SKIP_NORMALIZATION"]
    it "is normalized" do
      error_message = "The following files need to be normalized:\n" \
                      "#{non_normalized_paths.map { |path| "  #{path}" }.join("\n")}\n" \
                      "Please run `bundle exec i18n-tasks normalize --locales #{locales}` to fix them"

      expect(non_normalized_paths).to be_empty, error_message
    end
  end
end
