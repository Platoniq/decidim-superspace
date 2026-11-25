# frozen_string_literal: true

require "spec_helper"

checksums = [
  {
    package: "decidim-participatory_processes",
    files: {
      "/app/views/decidim/participatory_processes/participatory_processes/show.html.erb" => "fe4e2906ad3a43247ca2618d4cd6a8a3"
    }
  },
  {
    package: "decidim-assemblies",
    files: {
      "/app/views/decidim/assemblies/assemblies/show.html.erb" => "d70d93606f7d5d7f714dc91137166527"
    }
  },
  {
    package: "decidim-conferences",
    files: {
      "/app/views/decidim/conferences/conferences/show.html.erb" => "d8244b43d93c792962b2114f6e488b09"
    }
  }
]
describe "Overriden views", type: :view do
  checksums.each do |checksum|
    next unless Gem::Specification.find_by_name(checksum[:package])

    checksum[:files].each do |file, signature|
      it "#{file} matches checksum" do
        spec = Gem::Specification.find_by_name(checksum[:package])
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
