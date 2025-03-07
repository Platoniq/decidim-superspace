# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/superspaces/version"

Gem::Specification.new do |s|
  s.version = Decidim::Superspaces::VERSION
  s.authors = ["Francisco Bolívar"]
  s.email = ["francisco.bolivar@nazaries.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://platoniq.net"
  s.metadata = {
    "bug_tracker_uri" => "https://github.com/platoniq/decidim-superspace/issues",
    "source_code_uri" => "https://github.com/platoniq/decidim-superspace"
  }
  s.required_ruby_version = "~> 3.1"

  s.name = "decidim-superspaces"
  s.summary = "A decidim superspaces module"
  s.description = "A participatory space to jointly manage assemblies and processes."

  s.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").select do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w(app/ config/ db/ lib/ LICENSE-AGPLv3.txt Rakefile README.md))
    end
  end

  s.add_dependency "decidim-core", Decidim::Superspaces::COMPAT_DECIDIM_VERSION
  s.add_dependency "decidim-conferences", Decidim::Superspaces::COMPAT_DECIDIM_VERSION
  s.add_dependency "deface", "~> 1.9"
end
