# frozen_string_literal: true

require "spec_helper"

checksums = [
  {
    package: "decidim-participatory_processes",
    files: {
      "/app/views/decidim/participatory_processes/participatory_processes/show.html.erb" => "e4016fe96d932a2da2d483a0c56d3ee7"
    }
  },
  {
    package: "decidim-assemblies",
    files: {
      "/app/views/decidim/assemblies/assemblies/show.html.erb" => "92a7c4c48ecaa84bd8746b5b662eb186"
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
    spec = Gem::Specification.find_by_name(checksum[:package])
    checksum[:files].each do |file, signature|
      next unless spec

      it "#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
