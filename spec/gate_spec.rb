require 'spec_helper'

describe Fencepost::Gate do
  let(:subject) { Fencepost::Gate }

  describe "instantiation" do
    it "should accept model_list" do
      expect { Fencepost::Gate.new}.to raise_error
      expect { Fencepost::Gate.new({},{}) }.not_to raise_error
    end

    it "should be chainable" do
      g = subject.new({}, {})
      expect(g.allow(:this).deny(:that)).to be_a Fencepost::Gate
    end

  end

  describe "operation" do
    it "should store allows in an array" do
      g = subject.new({}, {})
      expect(g.allow(:this, :that).allow_array).to eq [:this, :that]
    end
  end
end
