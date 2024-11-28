class CreateDecidimSuperspaceParticipatorySpaces < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_superspace_superspace_participatory_spaces do |t|
      t.references :decidim_superspace_superspace, null: false, index: { name: "decidim_superspace_participatory_space_superspace" }
      t.references :participatory_space, polymorphic: true, index: { name: "decidim_superspace_participatory_space_participatory_space" }

      t.timestamps
    end
  end
end
