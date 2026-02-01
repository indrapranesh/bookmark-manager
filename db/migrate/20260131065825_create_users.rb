class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email, null: false              # Email is required
      t.string :password_digest, null: false    # Password is required

      t.timestamps
    end

    # Database-level uniqueness constraint
    add_index :users, :email, unique: true
  end
end
