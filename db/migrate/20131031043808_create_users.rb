class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :firstname
      t.text :lastname
      t.text :identificationtype
      t.text :identification
      t.text :status
      t.text :usertype
      t.text :email
      t.text :password
      t.text :code

      t.timestamps
    end
  end
end
