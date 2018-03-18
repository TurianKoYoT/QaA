class CreateVotesTable < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.integer :value
      t.references :votable, polymorphic: true, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
