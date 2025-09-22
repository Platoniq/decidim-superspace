# frozen_string_literal: true

Rake::Task["decidim:choose_target_plugins"].enhance do
  ENV["FROM"] = "#{ENV.fetch("FROM", nil)},decidim_superpaces" unless ENV["FROM"].to_s.include?("decidim_superpaces")
end
