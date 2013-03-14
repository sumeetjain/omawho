class AddSocialToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook, :string
    add_column :users, :pinterest, :string
    add_column :users, :linkedin, :string
    add_column :users, :github, :string
    add_column :users, :googleplus, :string
    add_column :users, :dribbble, :string
  end
end
