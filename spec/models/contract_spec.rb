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
      note: 'Lorem ipsum' * 10,
      price: 5
    )
  end

  # contractを対象としたテストを実施
  subject { @contract }

  # 属性に反応するか
  it { should respond_to(:offering) }

  # 適正なデータが検証に通るか
  it { should be_valid }
end
