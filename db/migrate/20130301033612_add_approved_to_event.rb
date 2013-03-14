class AddApprovedToEvent < ActiveRecord::Migration
  def change
    add_column :events, :approved, :boolean, :default => false
  end
end
