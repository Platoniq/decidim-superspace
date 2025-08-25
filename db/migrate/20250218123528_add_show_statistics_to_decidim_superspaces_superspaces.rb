class AddShowStatisticsToDecidimSuperspacesSuperspaces < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_superspaces_superspaces, :show_statistics, :boolean
  end
end
