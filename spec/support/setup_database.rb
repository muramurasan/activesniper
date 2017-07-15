ActiveRecord::Base.establish_connection(
    adapter:  'sqlite3',
    database: ':memory:'
)

class CreateAllTables < ActiveRecord::Migration[5.0]
  def self.up
    create_table(:users) do |t|
      t.string :account_name
      t.string :first_name # :before_validation
      t.string :last_name # :after_validation
      t.string :company_name # :after_rollback
      t.string :type_of_industry # :before_save
      t.integer :number_of_employees # :after_save
      t.string :reason # :around_save
      t.string :email # :before_update
      t.string :tel # :after_update
      t.integer :total_sales # :around_update
      t.boolean :admin # :after_commit
      t.timestamps
    end
  end
end

ActiveRecord::Migration.verbose = false
CreateAllTables.up
