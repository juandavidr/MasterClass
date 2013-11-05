class CreatePreregisterSubjects < ActiveRecord::Migration
  def change
    create_table :preregister_subjects do |t|
      t.integer :semester_id
      t.integer :subject_id
      t.integer :user_id
      t.string :status

      t.timestamps
    end
  end
end
