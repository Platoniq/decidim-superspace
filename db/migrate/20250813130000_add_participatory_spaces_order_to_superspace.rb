class AddParticipatorySpacesOrderToSuperspace < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_superspaces_superspaces, :participatory_spaces_order, :text
  end
end
