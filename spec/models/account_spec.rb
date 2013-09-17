require 'spec_helper'

describe Account do
  # :userを作成
  let(:user) { FactoryGirl.create(:user) }

  # @accountの作成
  before do
    @account = Account.new(
      user_id: user.id,
      balance: 1000
    )
  end

  # accountを対象としたテストを実施
  subject { @account }

  # 属性に反応するか
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should respond_to(:balance) }

  # 適正なデータが検証に通るか
  it { should be_valid }

  # ユーザーIDが設定されていない場合
  describe "when user_id is not present" do
    before { @account.user_id = nil }
    it { should_not be_valid }
  end

  # balanceが設定されていない場合
  describe "when balance is not present" do
    before { @account.balance = nil }
    it { should_not be_valid }
  end

  # balanceが文字列の場合
  describe "when balance is atring" do
    before { @account.balance = "a" }
    it { should_not be_valid }
  end

  # balanceが小数の場合
  describe "when balance is floating point number" do
    before { @account.balance = 1.1 }
    it { should_not be_valid }
  end

  # balanceが負の数の場合
  describe "when balance is minus number" do
    before { @account.balance = -1 }
    it { should_not be_valid }
  end

  # 支払いの実行
  describe "when transfer" do
    let(:payer) { FactoryGirl.create(:user) }
    let(:recipient) { FactoryGirl.create(:user) }

    before do
      @from = payer.create_account(balance: 1000)
      @to = recipient.create_account(balance: 1000)
    end

    # 適正な支払いの場合
    it "has valid amount should change accounts balance" do
      expect { Account.transfer(@from, @to, 100) }.to change{@from.balance}.by(-100)
      expect { Account.transfer(@from, @to, 100) }.to change{@to.balance}.by(100)
    end

    # 残高がマイナスになる支払いの場合
    it "has invalid amount should raise ActiveRecord::RecordInvalid" do
      lambda{Account.transfer(@from, @to, 2000)}.should
        raise_error(ActiveRecord::RecordInvalid)
    end
  end
    
end
