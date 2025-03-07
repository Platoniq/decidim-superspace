# frozen_string_literal: true

require "spec_helper"

checksums = [
  {
    package: "decidim-participatory_processes",
    files: {
      "/app/views/decidim/participatory_processes/participatory_processes/show.html.erb" => "a3c3b3d6a8ddf8083d0605090c946857"
    }
  },
  {
    package: "decidim-assemblies",
    files: {
      "/app/views/decidim/assemblies/assemblies/show.html.erb" => "c6cf7db86a379a0d729ad0c95ab7111e"
    }
  },
  {
    package: "decidim-conferences",
    files: {
      "/app/views/decidim/conferences/conferences/show.html.erb" => "eb94f807d798fe1ed4d1404dd1dfcad9"
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
