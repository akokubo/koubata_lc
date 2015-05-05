require 'rails_helper'

describe Message do
  # 促成の生成
  let(:sender) { FactoryGirl.create(:user) }
  let(:recepient) { FactoryGirl.create(:user) }

  # messageの生成
  let(:message) do
    Message.new(
      subject: 'Lorem ipsum',
      body: 'Lorem ipsum' * 5,
      sender: sender,
      recepient: recepient
    )
  end

  # messageをテストの対象とする
  subject { message }

  # 適正なデータは検証に通る
  it { should be_valid }

  # 属性に応答するか
  it { should respond_to(:sender) }
  it { expect(message.sender).to eq sender }
  it { should respond_to(:recepient) }
  it { expect(message.recepient).to eq recepient }
  it { should respond_to(:subject) }
  it { expect(message.subject).to eq 'Lorem ipsum' }
  it { should respond_to(:body) }
  it { expect(message.body).to eq 'Lorem ipsum' * 5 }

  # senderが存在しない場合
  describe 'when sender is not present' do
    before { message.sender = nil }
    it { should_not be_valid }
  end

  # recepientが存在しない場合
  describe 'when recepient is not present' do
    before { message.recepient = nil }
    it { should_not be_valid }
  end

  # subjectが存在しない場合
  describe 'when subject is not present' do
    before { message.subject = nil }
    it { should_not be_valid }
  end

  # bodyが存在しない場合
  describe 'when body is not present' do
    before { message.body = nil }
    it { should_not be_valid }
  end

  # Messageを生成した場合
  describe 'when message created' do
    before { message.save }
    it { expect(message.sender).to eq(sender) }
    it { expect(message.recepient).to eq(recepient) }
  end
end
