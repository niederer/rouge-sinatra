class CreateEvent < ActiveRecord::Migration[5.2]
  def self.up
    create_table :events do |t|
      t.string :title
      t.date :start_date
    end
  end

  def self.down
    drop_table :events
  end
end
