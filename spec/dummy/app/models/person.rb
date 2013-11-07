class Person < ActiveRecord::Base
  has_many :addresses, dependent: :destroy

  accepts_nested_attributes_for :addresses
end
