require 'rails_helper'

describe Payment do
  # from/toの生成
  let(:payer) { FactoryGirl.create(:user) }
  let(:recipient) { FactoryGirl.create(:user) }

  let(:user) { payer.create_account(balance: 1000) }
  let(:partner) { recipient.create_account(balance: 1000) }

  # paymentの生成
  before do
    @payment = Payment.new(
      user_id: user.id,
      partner_id: partner.id,
      subject: 'Lorem ipsum',
      amount: -100,
      direction: 'deposit',
      comment: 'Lorem ipsum' * 5
    )
  end

  # paymentをテストの対象とする
  subject { @payment }

  # 適正なデータは検証に通る
  it { should be_valid }

  # 属性に反応するか
  it { should respond_to(:subject) }
  it { should respond_to(:amount) }
  it { should respond_to(:direction) }
  it { should respond_to(:comment) }

  # userメソッドに応答する
  describe 'user methods' do
    it { should respond_to(:user) }
    it { expect(@payment.user).to eq user }
  end

  # partnerメソッドに応答する
  describe 'user methods' do
    it { should respond_to(:partner) }
    it { expect(@payment.partner).to eq partner }
  end

  # from_idが存在しない場合
  describe 'when user_id is not present' do
    before { @payment.user_id = nil }
    it { should_not be_valid }
  end

  # to_idが存在しない場合
  describe 'when partner_id is not present' do
    before { @payment.partner_id = nil }
    it { should_not be_valid }
  end

  # subjectが存在しない場合
  describe 'when subject is not present' do
    before { @payment.subject = nil }
    it { should_not be_valid }
  end

  # amountが存在しない場合
  describe 'when amount is not present' do
    before { @payment.amount = nil }
    it { should_not be_valid }
  end

  # amountが文字列の場合
  describe 'when amount is string' do
    before { @payment.amount = 'a' }
    it { should_not be_valid }
  end

  # amountが小数の場合
  describe 'when amount is floating point number' do
    before { @payment.amount = 1.1 }
    it { should_not be_valid }
  end

  # amountが負の数の場合
  describe 'when amount is plus number' do
    before { @payment.amount = 1 }
    it { should_not be_valid }
  end

  # paymentの正常実行
  describe 'when valid execute' do
    it "should decrease payer's balance" do
      expect { Account.transfer(@payment.user, @payment.partner, @payment.amount, @payment.subject, @payment.comment) }.to change { @payment.user.balance }.by(-@payment.amount)
    end

    it "should increase recipient's balance" do
      expect { Account.transfer(@payment.user, @payment.partner, @payment.amount, @payment.subject, @payment.comment) }.to change { @payment.partner.balance }.by(@payment.amount)
    end
  end

  # paymentの異常実行
  describe 'when invalid execute' do
    before { @payment.amount = 2000 }

    it 'should raise ActiveRecord::RecordInvalid' do
      expect { Account.transfer(@payment.user, @payment.partner, @payment.amount, @payment.subject, @payment.comment) }.to raise_error(ActiveRecord::RecordInvalid)

#      expect { @payment.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
