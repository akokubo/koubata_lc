require 'rails_helper'

describe Entrust do
  let(:owner) { FactoryGirl.create(:user) }
  let(:entrustor) { FactoryGirl.create(:user) }
  let(:category) { FactoryGirl.create(:category) }
  let(:want) do
    owner.wants.create(
      title: 'Lorem ipsum',
      category_id: category.id,
      description: 'Lorem ipsum' * 5,
      price: '5 points',
      expired_at: 1.day.from_now
    )
  end

  # @entrustの作成
  before do
    @entrust = want.entrusts.build(
      user: entrustor,
      note: 'Lorem ipsum' * 10
    )
  end

  # entrustを対象としたテストを実施
  subject { @entrust }

  # 属性に反応するか
  it { should respond_to(:want) }
  it { should respond_to(:user) }
  it { expect(@entrust.user).to eq entrustor }
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
    before { @entrust.user_id = nil }
    it { should_not be_valid }
  end

  # 採用日時が設定されている場合
  describe 'when owner_contracted_at is present' do
    before { @entrust.owner_contracted_at = 2.day.ago }
    it { should be_valid }
  end

  # 採用日時が設定されている場合
  describe 'when user_contracted_at is present' do
    before { @entrust.user_contracted_at = 2.day.ago }
    it { should be_valid }
  end

  # 支払日時が設定されている場合
  describe 'when paid_at is present' do
    before { @entrust.paid_at = 1.day.ago }
    it { should be_valid }
  end

  # 支払日時が設定されている場合
  describe 'when expected_at is present' do
    before { @entrust.expected_at = 1.day.ago }
    it { should be_valid }
  end

  # 支払日時が設定されている場合
  describe 'when performed_at is present' do
    before { @entrust.performed_at = 1.day.ago }
    it { should be_valid }
  end

  # 支払日時が設定されている場合
  describe 'when owner_canceled_at is present' do
    before { @entrust.owner_canceled_at = 1.day.ago }
    it { should be_valid }
  end

  # 支払日時が設定されている場合
  describe 'when user_canceled_at is present' do
    before { @entrust.user_canceled_at = 1.day.ago }
    it { should be_valid }
  end
end
