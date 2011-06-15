class CreateTimesheets < ActiveRecord::Migration
  def self.up
    create_table :timesheets do |t|
      t.datetime   :from
      t.datetime   :to
      t.string     :room
      t.references :course

      t.timestamps
    end
  end

  def self.down
    drop_table :timesheets
  end
end
