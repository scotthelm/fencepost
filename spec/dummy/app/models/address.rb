class Address < ActiveRecord::Base
  belongs_to :person
  belongs_to :address_type

  accepts_nested_attributes_for :address_type
end
