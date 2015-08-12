require 'rails_helper'

describe Payment do
  # from/toの生成
  let(:sender)    { FactoryGirl.create(:user) }
  let(:recepient) { FactoryGirl.create(:user) }

  let(:sender_account)    { sender.create_account(balance: 1000) }
  let(:recepient_account) { recepient.create_account(balance: 1000) }

  # paymentの生成
  before do
    amount = 100
    @payment = Payment.new(
      sender: sender,
      recepient: recepient,
      subject: 'Lorem ipsum',
      amount: amount,
      comment: 'Lorem ipsum' * 5,
      sender_balance_before:    sender_account.balance,
      sender_balance_after:     sender_account.balance - amount,
      recepient_balance_before: recepient_account.balance,
      recepient_balance_after:  recepient_account.balance + amount
    )
  end

  # paymentをテストの対象とする
  subject { @payment }

  # 適正なデータは検証に通る
  it { should be_valid }

  # 属性に反応するか
  it { should respond_to(:subject) }
  it { should respond_to(:amount) }
  it { should respond_to(:comment) }
  it { should respond_to(:sender_balance_before) }
  it { should respond_to(:sender_balance_after) }
  it { should respond_to(:recepient_balance_before) }
  it { should respond_to(:recepient_balance_after) }

  # userメソッドに応答する
  describe 'user methods' do
    it { should respond_to(:sender) }
    it { expect(@payment.sender).to eq sender }
  end

  # partnerメソッドに応答する
  describe 'user methods' do
    it { should respond_to(:recepient) }
    it { expect(@payment.recepient).to eq recepient }
  end

  # from_idが存在しない場合
  describe 'when sender_id is not present' do
    before { @payment.sender_id = nil }
    it { should_not be_valid }
  end

  # to_idが存在しない場合
  describe 'when recepient_id is not present' do
    before { @payment.recepient_id = nil }
    it { should_not be_valid }
  end

  # subjectが存在しない場合
  describe 'when subject is not presentshould set subject "無題"' do
    before do
      @payment.subject = nil
      @payment.save
    end
    it { expect(@payment.subject).to eq '無題' }
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
  describe 'when amount is minus number' do
    before { @payment.amount = -1 }
    it { should_not be_valid }
  end

  # amountが負の数の場合
  describe 'when sender_balance_after is not valid' do
    before { @payment.sender_balance_after += 1 }
    it { should_not be_valid }
  end

  # amountが負の数の場合
  describe 'when recepient_balance_after is not valid' do
    before { @payment.recepient_balance_after += 1 }
    it { should_not be_valid }
  end
end
