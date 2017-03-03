require 'rails_helper'

RSpec.describe Task, :type => :model do

  context "when built with name nil" do
    let(:task) { build :task, name: nil }
    it  {should_not be_valid}
  end

  context "when built with user_id nil" do
    let(:task) { build :task, user_id: nil }
    it {should_not be_valid}
  end

  context "when built when invalid end_date_on" do
    let(:task) { build :task, end_date_on: "20" }
    it {should_not be_valid}
  end
  context "when built with non-integer user_id" do
    let(:task) { build :task, user_id: "wee" }
    it {should_not be_valid}
  end
  context "" do
    let(:task) { build :task}
    it "has a valid factory" do
      expect(task).to be_valid
    end
  end

end
