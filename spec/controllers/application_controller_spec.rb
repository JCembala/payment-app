require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  describe "#current_user" do
    it "returns the first user" do
      create(:user)

      expect(subject.current_user).to eq(User.first)
    end
  end
end
