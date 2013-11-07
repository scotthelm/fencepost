require 'spec_helper'

describe PeopleController do
  describe "acts_as_fencepost" do
    it "has a strong_params method" do
      expect(controller.strong_params).to be_a(StrongParamGenerator)
    end

    it "has a person_params method" do
      post :create, person: {first_name: "Lou"}
      expect(controller.strong_params.person_params).to eq({
        "first_name" => "Lou"
      })
    end
  end
end
