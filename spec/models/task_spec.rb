require 'rails_helper'

RSpec.describe Task, :type => :model do
  subject {
  described_class.new(name: "Anything", description: "Lorem ipsum", end_date_on: DateTime.now + 1.week, user_id: 1)}
  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a use_id" do
    subject.user_id = nil
    expect(subject).to_not be_valid
  end

  it "is not valid with a end_date" do
    subject.end_date_on = "12"
    expect(task).to_not be_valid
  end

  it "is not valid with non-integer user_id" do
    subject.user_id = "qw"
    expect(subject).to_not be_valid
  end
end
