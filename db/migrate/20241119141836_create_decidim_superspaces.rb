class CreateDecidimSuperspaces < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_superspace_superspaces do |t|
      t.references :decidim_organization, null: false, index: true
      t.jsonb :title
      t.string :locale

      t.timestamps
    end
  end
end
