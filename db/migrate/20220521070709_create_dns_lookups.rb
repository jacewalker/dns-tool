class CreateDnsLookups < ActiveRecord::Migration[7.0]
  def change
    create_table :dns_lookups do |t|
      t.string :domain

      t.timestamps
    end
  end
end
