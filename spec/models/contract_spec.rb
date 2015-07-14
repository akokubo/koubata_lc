require 'rails_helper'

describe Contract do
  let(:owner) { FactoryGirl.create(:user) }
  let(:contractor) { FactoryGirl.create(:user) }
  let(:category) { FactoryGirl.create(:category) }
  let(:offering) do
    owner.offerings.create(
      title: 'Lorem ipsum',
      category_id: category.id,
      description: 'Lorem ipsum' * 5,
      price: '5 points',
      expired_at: 1.day.from_now
    )
  end

  # @contractの作成
  before do
    @contract = offering.contracts.build(
      user: contractor,
      note: 'Lorem ipsum' * 10
    )
  end

  # contractを対象としたテストを実施
  subject { @contract }

  # 属性に反応するか
  it { should respond_to(:offering) }
  it { should respond_to(:user) }
  it { expect(@contract.user).to eq contractor }
  it { should respond_to(:note) }
  it { should respond_to(:owner_contracted_at) }
  it { should respond_to(:user_contracted_at) }
  it { should respond_to(:paid_at) }
  it { should respond_to(:expected_at) }
  it { should respond_to(:performed_at) }
  it { should respond_to(:owner_canceled_at) }
  it { should respond_to(:user_canceled_at) }

  # 適正なデータが検証に通るか
  it { should be_valid }

  # ユーザーIDが設定されていない場合
  describe 'when user_id is not present' do
    before { @contract.user_id = nil }
    it { should_not be_valid }
  end

  # 採用日時が設定されている場合
  describe 'when owner_contracted_at is present' do
    before { @contract.owner_contracted_at = 2.day.ago }
    it { should be_valid }
  end

  # 採用日時が設定されている場合
  describe 'when user_contracted_at is present' do
    before { @contract.user_contracted_at = 2.day.ago }
    it { should be_valid }
  end

  # 支払日時が設定されている場合
  describe 'when paid_at is present' do
    before { @contract.paid_at = 1.day.ago }
    it { should be_valid }
  end

  # 支払日時が設定されている場合
  describe 'when expected_at is present' do
    before { @contract.expected_at = 1.day.ago }
    it { should be_valid }
  end

  # 支払日時が設定されている場合
  describe 'when performed_at is present' do
    before { @contract.performed_at = 1.day.ago }
    it { should be_valid }
  end

  # 支払日時が設定されている場合
  describe 'when owner_canceled_at is present' do
    before { @contract.owner_canceled_at = 1.day.ago }
    it { should be_valid }
  end

  # 支払日時が設定されている場合
  describe 'when user_canceled_at is present' do
    before { @contract.user_canceled_at = 1.day.ago }
    it { should be_valid }
  end
end
