require 'rails_helper'

describe Entry do
  let(:owner) { FactoryGirl.create(:user) }
  let(:user) { FactoryGirl.create(:user) }
  let(:category) { FactoryGirl.create(:category) }
  let(:task) do
    owner.tasks.create(
      title: 'Lorem ipsum',
      category_id: category.id,
      description: 'Lorem ipsum' * 5,
      price: '5 points',
      expired_at: 1.day.from_now,
      type: "Offering"
    )
  end

  # @entryの作成
  before do
    @entry = task.entries.build(
      user: user,
      note: 'Lorem ipsum' * 10,
      price: 5
    )
  end

  # entryを対象としたテストを実施
  subject { @entry }

  # 属性に反応するか
  it { should respond_to(:task) }
  it { should respond_to(:owner) }
  it { expect(@entry.task.user).to eq owner }
  it { should respond_to(:user) }
  it { expect(@entry.user).to eq user }
  it { should respond_to(:price) }
  it { should respond_to(:note) }
  it { should respond_to(:owner_committed_at) }
  it { should respond_to(:user_committed_at) }
  it { should respond_to(:paid_at) }
  it { should respond_to(:expected_at) }
  it { should respond_to(:performed_at) }
  it { should respond_to(:owner_canceled_at) }
  it { should respond_to(:user_canceled_at) }

  # 適正なデータが検証に通るか
  it { should be_valid }

  # ユーザーIDが設定されていない場合
  describe 'when user_id is not present' do
    before { @entry.user_id = nil }
    it { should_not be_valid }
  end

  # 採用日時が設定されている場合
  describe 'when owner_committed_at is present' do
    before { @entry.owner_committed_at = 2.day.ago }
    it { should be_valid }
  end

  # 採用日時が設定されている場合
  describe 'when user_committed_at is present' do
    before { @entry.user_committed_at = 2.day.ago }
    it { should be_valid }
  end

  # 支払日時が設定されている場合
  describe 'when paid_at is present' do
    before { @entry.paid_at = 1.day.ago }
    it { should be_valid }
  end

  # 支払日時が設定されている場合
  describe 'when expected_at is present' do
    before { @entry.expected_at = 1.day.ago }
    it { should be_valid }
  end

  # 支払日時が設定されている場合
  describe 'when performed_at is present' do
    before { @entry.performed_at = 1.day.ago }
    it { should be_valid }
  end

  # 支払日時が設定されている場合
  describe 'when owner_canceled_at is present' do
    before { @entry.owner_canceled_at = 1.day.ago }
    it { should be_valid }
  end

  # 支払日時が設定されている場合
  describe 'when user_canceled_at is present' do
    before { @entry.user_canceled_at = 1.day.ago }
    it { should be_valid }
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
end
