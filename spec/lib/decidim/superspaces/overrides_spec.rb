# frozen_string_literal: true

require "spec_helper"

checksums = [
  {
    package: "decidim-participatory_processes",
    files: {
      "/app/views/decidim/participatory_processes/participatory_processes/show.html.erb" => "aef7b518b8ac648a3cdb3e34c7351c8b"
    }
  },
  {
    package: "decidim-assemblies",
    files: {
      "/app/views/decidim/assemblies/assemblies/show.html.erb" => "5d776b77fdf04061d2e32818a4d5033e"
    }
  },
  {
    package: "decidim-conferences",
    files: {
      "/app/views/decidim/conferences/conferences/show.html.erb" => "f473d522ddc4c5f3352f3fc55cffdd7d"
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
