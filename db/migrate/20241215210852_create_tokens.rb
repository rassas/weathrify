class CreateTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :tokens do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.text :token, null: false, index: { unique: true }
      t.datetime :expires_at

      t.timestamps
    end
  end
end
