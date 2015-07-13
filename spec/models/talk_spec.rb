require 'rails_helper'

describe Talk do
  # 促成の生成
  let(:sender) { FactoryGirl.create(:user) }
  let(:recepient) { FactoryGirl.create(:user) }

  # talkの生成
  let(:talk) do
    Talk.new(
      body: 'Lorem ipsum' * 5,
      sender: sender,
      recepient: recepient
    )
  end

  # talkをテストの対象とする
  subject { talk }

  # 適正なデータは検証に通る
  it { should be_valid }

  # 属性に応答するか
  it { should respond_to(:sender) }
  it { expect(talk.sender).to eq sender }
  it { should respond_to(:recepient) }
  it { expect(talk.recepient).to eq recepient }
  it { should respond_to(:body) }
  it { expect(talk.body).to eq 'Lorem ipsum' * 5 }

  # senderが存在しない場合
  describe 'when sender is not present' do
    before { talk.sender = nil }
    it { should_not be_valid }
  end

  # recepientが存在しない場合
  describe 'when recepient is not present' do
    before { talk.recepient = nil }
    it { should_not be_valid }
  end

  # bodyが存在しない場合
  describe 'when body is not present' do
    before { talk.body = nil }
    it { should_not be_valid }
  end

  # Talkを生成した場合
  describe 'when talk created' do
    before { talk.save }
    it { expect(talk.sender).to eq(sender) }
    it { expect(talk.recepient).to eq(recepient) }
  end
end
