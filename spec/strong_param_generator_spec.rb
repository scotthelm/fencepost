require 'spec_helper'

describe Fencepost::Fencepost do
  let(:subject) { Fencepost::Fencepost }
  let(:test_object) {Person.new}

  describe "models" do
    it "should have a class-level list of models" do
      expect(subject.models).to be_an(Array)
    end

    it "should have a params method for each model in models" do
      static_ms = (subject.instance_methods - Object.methods).size
      method_size = (subject.new({}).methods - Object.methods).size - static_ms
      expect(method_size) .to eq (subject.models.size)
    end
  end

  describe "returned params" do
    before(:each) do
      file_name = "#{Rails.root}/config/fencepost.yml"
      Fencepost::Fencepost.model_list = YAML.load_file(file_name) if File.exists?(file_name)
    end
    it "should raise error if params are empty" do
      expect(-> { subject.new({}).person_params} ).to raise_error(
        ActionController::ParameterMissing)
    end

    it "should return permitted params from base model" do
      a = subject.new({person: {first_name: "Foo", last_name: "Quux", bar: "Foo"}})
      expect(a.person_params).to eq({"first_name" => "Foo", "last_name" => "Quux"})
    end

    it "should not raise error if params contain extra parameters" do
      a = subject.new(person: {first_name: "Foo", updated_at: Time.now})
      expect(a.person_params).to eq({"first_name" => "Foo"})
    end

    it "should not allow model attributes that have been removed in config" do
      a = subject.new(person: {first_name: "Foo", dob: Time.now})
      expect(a.person_params).to eq({"first_name" => "Foo"})
    end

    it "association_classes should return array of associations" do
      a = subject.new({
        person: {
          first_name: "Foo",
          addresses_attributes: { "0" => {
              address_line_1: "123 test st",
              city: "wewt",
              state_province: "NE"
            }
          }
        }
      })

      expect(a.person_params).to eq({
        "first_name" => "Foo",
        "addresses_attributes" => { "0" => {
          "address_line_1" => "123 test st",
          "city" => "wewt",
          "state_province" => "NE"
        }}
      })

      expect { Person.create(a.person_params) }.not_to raise_error
    end

    it "should return a reference to self on allows" do
      a = subject.new({})
      expect(a.allow(:dob)).to be_a(Fencepost::Fencepost)
    end
    it "should return a reference to self on deny" do
      a = subject.new({})
      expect(a.deny(:dob)).to be_a(Fencepost::Fencepost)
    end

    it "should be chainable" do
      a = subject.new({})
      expect(a.allow(:x).deny(:y).allow(:p)).to be_a(Fencepost::Fencepost)
    end

    it "should allow attributes if explcitly allowed in method call" do
      dob = Time.now
      a = subject.new({"person" => {"first_name" => "Foo", "dob" => dob}})
      expect(a.allow(:dob).person_params).to eq(
        {"first_name" => "Foo", "dob" => dob})
    end

    it "should deny attributes if explicitly denied in method call" do
      a = subject.new({"person" => {"first_name" => "Foo", "last_name" => "Bar"}})
      expect(a.deny(:last_name).person_params).to eq( {"first_name" => "Foo"})
      expect { Person.create(a.deny(:last_name).person_params) }.not_to raise_error
    end

    it "should deny nested attrbutes if explicitly denied" do
      a = subject.new({"person" => {
        "first_name" => "Foo",
        "addresses_attributes" => {
          "address_line_1" => "123 test st",
          "city" => "wewt",
          "state_province" => "NE",
          "address_types_attributes" => {
            "key" => "wewt",
            "label" => "W00t!"
          }}}})

      expect(a.deny(
        addresses_attributes:[
          :city,
          address_types_attributes: [
            :label
          ]
        ]).person_params).to eq(
          {"first_name" => "Foo",
          "addresses_attributes" => {
            "address_line_1" => "123 test st",
            "state_province" => "NE",
            "address_types_attributes" => {
              "key" => "wewt"
            }}})
    end

    it "should allow for development mode (model loading on the fly)" do
      Fencepost.configuration.dev_mode = true
      dob = Time.now
      a = subject.new({"person" => {"first_name" => "Foo", "dob" => dob}})
      expect(a.person_params).to eq({"first_name" => "Foo", "dob" => dob})
      Fencepost.configuration.dev_mode = false
    end
  end
end
