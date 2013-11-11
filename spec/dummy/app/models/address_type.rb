class AddressType < ActiveRecord::Base
  has_many :addresses, :inverse_of => :address_type
end
