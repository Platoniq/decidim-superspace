# frozen_string_literal: true

require "spec_helper"

checksums = [
  {
    package: "decidim-participatory_processes",
    files: {
      "/app/views/decidim/participatory_processes/participatory_processes/show.html.erb" => "db96f2d658f6b0103bc44b2611a816f4"
    }
  },
  {
    package: "decidim-assemblies",
    files: {
      "/app/views/decidim/assemblies/assemblies/show.html.erb" => "3921d7ce8235622deadc151b9a24ee2b"
    }
  },
  {
    package: "decidim-conferences",
    files: {
      "/app/views/decidim/conferences/conferences/show.html.erb" => "d803dd234af6690136fb22b56e491f8c"
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
