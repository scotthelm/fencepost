Rails.application.eager_load!
Fencepost::Fencepost.model_list = YAML.load(
<<-contents
---
:address:
  :model: !ruby/class 'Address'
  :attributes:
  - :person_id
  - :address_line_1
  - :address_line_2
  - :city
  - :state_province
  - :postal_code
  :demodulized_name: :address
  :nested_collection_name: :addresses
  :nested_attributes_name: :addresses_attributes
  :nested_attributes_options: {}
:person:
  :model: !ruby/class 'Person'
  :attributes:
  - :first_name
  - :last_name
  - :dob
  :demodulized_name: :person
  :nested_collection_name: :people
  :nested_attributes_name: :people_attributes
  :nested_attributes_options:
    :addresses:
      :allow_destroy: false
      :update_only: false

contents
)
