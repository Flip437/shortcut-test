class CreateBacklogs < ActiveRecord::Migration[6.1]
  def change
    create_table :backlogs do |t|
      t.string :attribut_name
      t.string :attribut_value
      t.references :backlogable, polymorphic: true

      t.timestamps
    end
  end
end
