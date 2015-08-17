require 'rails_helper'

describe Entry do
  let(:owner) { FactoryGirl.create(:user) }
  let(:user) { FactoryGirl.create(:user) }
  let(:task) { FactoryGirl.create(:task, user: owner) }
  let(:sender_account)    { FactoryGirl.create(:account, user: user) }
  let(:recepient_account) { FactoryGirl.create(:account, user: owner) }

  # @entryの作成
  before do
    @entry = FactoryGirl.build(:entry, task: task, user: user)
  end

  # entryを対象としたテストを実施
  subject { @entry }

  # 属性に反応するか
  it { should respond_to(:task) }
  it { should respond_to(:task_id) }
  it { should respond_to(:user) }
  it { expect(@entry.user).to eq user }
  it { should respond_to(:user_id) }
  it { should respond_to(:price) }
  it { should respond_to(:payment) }
  it { should respond_to(:payment_id) }
  it { should respond_to(:note) }

  #  メソッドに反応するか
  it { should respond_to(:owner) }
  it { expect(@entry.owner).to eq owner }
  it { should respond_to(:owner?) }
  it { expect(@entry.owner?(@entry.owner)).to be true }
  it { expect(@entry.owner?(@entry.user)).to be false }
  it { should respond_to(:user?) }
  it { expect(@entry.user?(@entry.user)).to be true }
  it { expect(@entry.user?(@entry.owner)).to be false }
  it { should respond_to(:performer?) }
  it { should respond_to(:payer?) }
  it { should respond_to(:payee) }
  it { should respond_to(:partner_of) }
  it { expect(@entry.partner_of(owner)).to eq user }
  it { expect(@entry.partner_of(user)).to eq owner }
  it { should respond_to(:url) }

  # 適正なデータが検証に通るか
  it { should be_valid }

  # タスクIDが設定されていない場合
  describe 'when task_id is not present' do
    before { @entry.task_id = nil }
    it { should_not be_valid }
  end

  # ユーザーIDが設定されていない場合
  describe 'when user_id is not present' do
    before { @entry.user_id = nil }
    it { should_not be_valid }
  end

  # priceが存在しない場合
  describe 'when price is not present' do
    before { @entry.price = nil }
    it { should_not be_valid }
  end

  # priceが文字列の場合
  describe 'when price is string' do
    before { @entry.price = 'a' }
    it { should_not be_valid }
  end

  # priceが小数の場合
  describe 'when price is floating point number' do
    before { @entry.price = 1.1 }
    it { should_not be_valid }
  end

  # priceが負の数の場合
  describe 'when price is minus number' do
    before { @entry.price = -1 }
    it { should_not be_valid }
  end

  # expected_at が存在しない場合
  describe 'when expected_at is not present' do
    before { @entry.expected_at = nil }
    it { should_not be_valid }
  end
end
