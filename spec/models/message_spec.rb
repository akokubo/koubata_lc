require 'spec_helper'

describe Message do

  # from/toの生成
  let(:from) { FactoryGirl.create(:user) }
  let(:to) { FactoryGirl.create(:user) }

  # messageの生成
  let(:message) do
    from.messages.build(
      to_id: to.id,
      subject: "Lorem ipsum",
      body: "Lorem ipsum" * 5
    )
  end

  # messageをテストの対象とする
  subject { message }

  # 適正なデータは検証に通る
  it { should be_valid }

  # from/toメソッドに応答する
  describe "from/to methods" do
    it { should respond_to(:from) }
    its(:from) { should eq from }
    it { should respond_to(:to) }
    its(:to) { should eq to }
  end

  # from_idが存在しない場合
  describe "when from_id is not present" do
    before { message.from_id = nil }
    it { should_not be_valid }
  end

  # to_idが存在しない場合
  describe "when to_id is not present" do
    before { message.to_id = nil }
    it { should_not be_valid }
  end

  # subjectが存在しない場合
  describe "when subject is not present" do
    before { message.subject = nil }
    it { should_not be_valid }
  end

  # bodyが存在しない場合
  describe "when body is not present" do
    before { message.body = nil }
    it { should_not be_valid }
  end
end
