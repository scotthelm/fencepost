require 'spec_helper'

describe PeopleController, type: :controller do
  describe "acts_as_fencepost" do
    it "has a fencepost method" do
      expect(controller.fencepost).to be_a(Fencepost::Fencepost)
    end

    it "has a person_params method" do
      post :create, params: {person: { first_name: 'Lou' }}
      expect(controller.fencepost.person_params).to eq("first_name" => "Lou")
    end
  end
end
