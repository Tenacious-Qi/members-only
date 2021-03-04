class AddMemberIdToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :member_id, :integer, null: false
  end
end
