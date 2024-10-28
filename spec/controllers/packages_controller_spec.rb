require "rails_helper"

RSpec.describe PackagesController, type: :controller do
  describe "GET #index" do
    it "returns a success response" do
      get :index

      expect(response).to be_successful
    end

    it "assigns @packages" do
      package = Package.create(name: "Test Package", price_cents: 1000)

      get :index

      expect(assigns(:packages)).to eq([package])
    end

    it "renders the index template" do
      get :index

      expect(response).to render_template("index")
    end
  end
end
