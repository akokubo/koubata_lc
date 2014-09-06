require 'rails_helper'

describe Message do

  # 促成の生成
  let(:sender) { FactoryGirl.create(:user) }
  let(:recepient) { FactoryGirl.create(:user) }

  # messageの生成
  let(:message) do
    message = Message.new(
      subject: "Lorem ipsum",
      body: "Lorem ipsum" * 5,
      sender_id: sender.id,
      recepient_id: recepient.id
    )
  end

  # messageをテストの対象とする
  subject { message }

  # 適正なデータは検証に通る
  it { should be_valid }

  # sender/recepientメソッドに応答する
  describe "sender/recepient methods" do
    it { should respond_to(:sender_id) }
    it { expect(message.sender_id).to eq sender.id }
    it { should respond_to(:recepient_id) }
    it { expect(message.recepient_id).to eq recepient.id }
    it { should respond_to(:subject) }
    it { expect(message.subject).to eq "Lorem ipsum" }
    it { should respond_to(:body) }
    it { expect(message.body).to eq "Lorem ipsum" * 5 }
  end

  # sender_idが存在しない場合
  describe "when sender_id is not present" do
    before { message.sender_id = nil }
    it { should_not be_valid }
  end

  # recepient_idが存在しない場合
  describe "when recepient_id is not present" do
    before { message.recepient_id = nil }
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

  # Messageを生成した場合
  describe "when message created" do
    before { message.save }
    it { expect(message.passings.first.user_id).to eq(recepient.id).or eq(sender.id) }
    it { expect(message.passings.last.user_id).to eq(recepient.id).or eq(sender.id) }
  end
end
