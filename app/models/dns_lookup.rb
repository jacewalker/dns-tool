class DnsLookup < ApplicationRecord
    validates :domain, presence: true
end
