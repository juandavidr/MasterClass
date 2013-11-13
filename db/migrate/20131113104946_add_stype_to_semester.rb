class AddStypeToSemester < ActiveRecord::Migration
  def change
    add_column :semesters, :stype, :string
  end
end
