require 'rails_helper'

describe Status do
  describe "colors" do
    describe "without a username" do
      it "shows the red light on if the last status is red" do
        FactoryGirl.create :status, red: true
        colors = Status.colors
        expect(colors[:red]).to be_truthy
      end

      it "shows the red light as a count if the last status is red" do
        FactoryGirl.create :status, red: true
        colors = Status.colors
        expect(colors[:red]).to eq(1)
      end

      it "shows the red and yellow lights on if the last status is yellow, but previous non-yellow was red" do
        FactoryGirl.create :status, red: true
        2.times { FactoryGirl.create :status, red: false, yellow: true }
        colors = Status.colors
        expect(colors[:yellow]).to be(true)
        expect(colors[:red]).to be_truthy
      end

      it "shows the red light on if the last status is green, but another project is red" do
        FactoryGirl.create :status, red: true
        FactoryGirl.create :status, red: false
        colors = Status.colors
        expect(colors[:red]).to be_truthy
      end
    end

    describe "with a username" do
      before do
        FactoryGirl.create :status, username: 'danielmorrison', red: true, yellow: true
      end

      it "shows the red light on if the last status is red" do
        FactoryGirl.create :status, username: 'collectiveidea', red: true
        colors = Status.colors('collectiveidea')
        expect(colors[:red]).to be_truthy
      end

      it "shows the red and yellow lights on if the last status is yellow, but previous non-yellow was red" do
        FactoryGirl.create :status, username: 'collectiveidea', red: true
        2.times { FactoryGirl.create :status, username: 'collectiveidea', red: false, yellow: true }
        colors = Status.colors('collectiveidea')
        expect(colors[:yellow]).to be(true)
        expect(colors[:red]).to be_truthy
      end

      it "shows the red light on if the last status is green, but another project is red" do
        FactoryGirl.create :status, username: 'collectiveidea', red: true
        FactoryGirl.create :status, username: 'collectiveidea', red: false
        colors = Status.colors('collectiveidea')
        expect(colors[:red]).to be_truthy
      end
    end

    describe "with multiple usernames" do
      it "shows the red light on if the last status is red" do
        FactoryGirl.create :status, username: 'collectiveidea', red: true,  yellow: false
        FactoryGirl.create :status, username: 'danielmorrison', red: false, yellow: true
        colors = Status.colors(['collectiveidea', 'danielmorrison'])
        expect(colors[:red]).to be_truthy
        expect(colors[:yellow]).to be(true)
      end
    end
  end

  describe "#name" do
    it "returns the full github-style name" do
      status = Status.new(username: "collectiveidea", project_name: "foo")
      expect(status.name).to eq("collectiveidea/foo")
    end
  end

  describe "#devices" do
    it "returns the list of Device objects that care about this status" do
      device1 = FactoryGirl.create(:device, usernames: ["collectiveidea"], projects: ["deadmanssnitch/foo"])
      device2 = FactoryGirl.create(:device, usernames: ["collectiveidea", "deadmanssnitch"])
      device3 = FactoryGirl.create(:device, usernames: ["deadmanssnitch"], projects: ["collectiveidea/foo"])
      device4 = FactoryGirl.create(:device, usernames: [], projects: ["collectiveidea/foo"])
      device5 = FactoryGirl.create(:device, usernames: ["deadmanssnitch"], projects: [])

      status = FactoryGirl.create(:status, username: "collectiveidea", project_name: "foo")

      expect(status.devices).to include(device1)
      expect(status.devices).to include(device2)
      expect(status.devices).to include(device3)
      expect(status.devices).to include(device4)
      expect(status.devices).to include(device4)
      expect(status.devices).not_to include(device5)
    end
  end
end
