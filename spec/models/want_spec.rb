require 'spec_helper'

describe Want do
  # :userとを作成
  let(:user) { FactoryGirl.create(:user) }

  # @wantの作成
  before do
    @want = user.wants.build(
      title: "Lorem ipsum",
      description: "Lorem ipsum" * 5,
      expired_at: 1.day.from_now
    )
  end

  # wantを対象としたテストを実施
  subject { @want }

  # 属性に反応するか
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should respond_to(:title) }
  it { should respond_to(:description) }
  it { should respond_to(:expired_at) }

  # 適正なデータが検証に通るか
  it { should be_valid }

  # ユーザーIDが設定されていない場合
  describe "when user_id is not present" do
    before { @want.user_id = nil }
    it { should_not be_valid }
  end


  # タイトルが設定されていない場合
  describe "when title is not present" do
    before { @want.title = nil }
    it { should_not be_valid }
  end

end
