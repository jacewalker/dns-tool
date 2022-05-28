class CreateDnsLookups < ActiveRecord::Migration[7.0]
  def change
    create_table :dns_lookups do |t|
      t.string :domain
      t.string :aRecord
      t.string :mxRecord
      t.string :txtRecord
      t.string :soaRecord
      t.string :nsRecord
      
      t.timestamps
    end
  end
end
