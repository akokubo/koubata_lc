require 'rails_helper'

describe Want do
  # :userと:categoryを作成
  let(:user) { FactoryGirl.create(:user) }
  let(:category) { FactoryGirl.create(:category) }

  # @wantの作成
  before do
    @want = user.wants.build(
      title: 'Lorem ipsum',
      category_id: category.id,
      description: 'Lorem ipsum' * 5,
      price: '5 points',
      expired_at: 1.day.from_now
    )
  end

  # wantを対象としたテストを実施
  subject { @want }

  # 属性に反応するか
  it { should respond_to(:user) }
  it { expect(@want.user).to eq user }
  it { should respond_to(:title) }
  it { should respond_to(:category_id) }
  it { should respond_to(:description) }
  it { should respond_to(:expired_at) }
  it { should respond_to(:entries) }
  it { should respond_to(:entrusts) }
  it { should respond_to(:closed_at) }

  # 適正なデータが検証に通るか
  it { should be_valid }

  # ユーザーIDが設定されていない場合
  describe 'when user_id is not present' do
    before { @want.user_id = nil }
    it { should_not be_valid }
  end

  # カテゴリーIDが設定されていない場合
  describe 'when category_id is not present' do
    before { @want.category_id = nil }
    it { should_not be_valid }
  end

  # タイトルが設定されていない場合
  describe 'when title is not present' do
    before { @want.title = nil }
    it { should_not be_valid }
  end

  # 価格が設定されていない場合
  describe 'when price is not present' do
    before { @want.price = nil }
    it { should_not be_valid }
  end

  # 表示期限が設定されていない場合
  describe 'when expired_at is not present' do
    before { @want.expired_at = nil }
    it { should be_valid }
  end

  # 表示期限を解除した場合
  describe 'when no_expiration is set' do
    before do
      @want.no_expiration = 1
      @want.save
    end
    it { expect(@want.expired_at).to eq nil }
  end
end
