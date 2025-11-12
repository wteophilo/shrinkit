class CreateUrls < ActiveRecord::Migration[8.0]
  def change
    create_table :urls do |t|
      t.string :short_code
      t.string :long_url

      t.timestamps
    end
  end
end
