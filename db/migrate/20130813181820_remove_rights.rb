class Right < ActiveRecord::Base
end

class RemoveRights < ActiveRecord::Migration
  def up
    drop_table :rights
  end

  def down
  end
end
