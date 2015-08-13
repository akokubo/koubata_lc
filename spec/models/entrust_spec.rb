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
      note: 'Lorem ipsum' * 10,
      price: 5
    )
  end

  # entrustを対象としたテストを実施
  subject { @entrust }

  # 属性に反応するか
  it { should respond_to(:want) }

  # 適正なデータが検証に通るか
  it { should be_valid }
end
