require 'rails_helper'

describe Offering do

  # :userと:categoryを作成
  let(:user) { FactoryGirl.create(:user) }
  let(:category) { FactoryGirl.create(:category) }

  # @offeringの作成
  before do
    @offering = user.offerings.build(
      title: "Lorem ipsum",
      category_id: category.id,
      description: "Lorem ipsum" * 5,
      price: "5 points",
      expired_at: 1.day.from_now
    )
  end

  # offeringを対象としたテストを実施
  subject { @offering }

  # 属性に反応するか
  it { should respond_to(:user) }
  it { expect(@offering.user).to eq user}

  it { should respond_to(:title) }

  it { should respond_to(:category_id) }

  it { should respond_to(:description) }
  it { should respond_to(:expired_at) }

  # 適正なデータが検証に通るか
  it { should be_valid }

  # ユーザーIDが設定されていない場合
  describe "when user_id is not present" do
    before { @offering.user_id = nil }
    it { should_not be_valid }
  end

  # カテゴリーIDが設定されていない場合
  describe "when category_id is not present" do
    before { @offering.category_id = nil }
    it { should_not be_valid }
  end

  # タイトルが設定されていない場合
  describe "when title is not present" do
    before { @offering.title = nil }
    it { should_not be_valid }
  end

  # 価格が設定されていない場合
  describe "when price is not present" do
    before { @offering.price = nil }
    it { should_not be_valid }
  end
end
