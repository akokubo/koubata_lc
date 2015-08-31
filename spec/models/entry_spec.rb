require 'rails_helper'

describe Entry do
  let(:owner) { FactoryGirl.create(:user) }
  let(:contractor) { FactoryGirl.create(:user) }
  let(:sender_account)    { FactoryGirl.create(:account, user: contractor) }
  let(:recepient_account) { FactoryGirl.create(:account, user: owner) }

  # @entryの作成
  before do
    @entry = FactoryGirl.build(:entry, owner: owner, contractor: contractor)
  end

  # entryを対象としたテストを実施
  subject { @entry }

  # 属性に反応するか
  it { should respond_to(:contractor) }
  it { expect(@entry.contractor).to eq contractor }
  it { should respond_to(:contractor_id) }
  it { should respond_to(:owner) }
  it { expect(@entry.owner).to eq owner }
  it { should respond_to(:owner_id) }
  it { should respond_to(:price) }
  it { should respond_to(:payment) }
  it { should respond_to(:payment_id) }
  it { should respond_to(:category) }
  it { should respond_to(:category_id) }
  it { should respond_to(:closed_at) }
  it { should respond_to(:description) }
  it { should respond_to(:expired_at) }
  it { should respond_to(:prior_price) }
  it { should respond_to(:title) }

  #  メソッドに反応するか
  it { should respond_to(:contractor?) }
  it { expect(@entry.owner?(@entry.contractor)).to be false }
  it { should respond_to(:owner?) }
  it { expect(@entry.owner?(@entry.owner)).to be true }
  it { expect(@entry.contractor?(@entry.contractor)).to be true }
  it { expect(@entry.contractor?(@entry.owner)).to be false }
  it { should respond_to(:performer?) }
  it { should respond_to(:payer?) }
  it { should respond_to(:payee) }
  it { should respond_to(:partner_of) }
  it { expect(@entry.partner_of(owner)).to eq contractor }
  it { expect(@entry.partner_of(contractor)).to eq owner }
  it { should respond_to(:url) }

  # 適正なデータが検証に通るか
  it { should be_valid }

  # 請負人IDが設定されていない場合
  describe 'when contractor_id is not present' do
    before { @entry.contractor_id = nil }
    it { should_not be_valid }
  end

  # 依頼人IDが設定されていない場合
  describe 'when owner_id is not present' do
    before { @entry.owner_id = nil }
    it { should_not be_valid }
  end

  # カテゴリーIDが設定されていない場合
  describe 'when category_id is not present' do
    before { @entry.category_id = nil }
    it { should_not be_valid }
  end

  # タイトルが設定されていない場合
  describe 'when title is not present' do
    before { @entry.title = nil }
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
