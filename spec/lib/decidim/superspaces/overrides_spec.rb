# frozen_string_literal: true

require "spec_helper"

checksums = [
  {
    package: "decidim-participatory_processes",
    files: {
      "/app/views/decidim/participatory_processes/participatory_processes/show.html.erb" => "b1ca9962640da5306bc74c75280e2f76"
    }
  },
  {
    package: "decidim-assemblies",
    files: {
      "/app/views/decidim/assemblies/assemblies/show.html.erb" => "91639376fd336908604a84530557cd09"
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
