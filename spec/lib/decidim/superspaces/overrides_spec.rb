# frozen_string_literal: true

require "spec_helper"

checksums = [
  {
    package: "decidim-participatory_processes",
    files: {
      "/app/views/decidim/participatory_processes/participatory_processes/show.html.erb" => "cd6ec19aeabe7cdcbfd17021b89ef268"
    }
  },
  {
    package: "decidim-assemblies",
    files: {
      "/app/views/decidim/assemblies/assemblies/show.html.erb" => "18d3ce456c24e0dcc958ed5d8cb2960b"
    }
  },
  {
    package: "decidim-conferences",
    files: {
      "/app/views/decidim/conferences/conferences/show.html.erb" => "e849c28ea6b3b23f6293b1812e7eeb57"
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
