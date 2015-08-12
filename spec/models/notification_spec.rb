require 'rails_helper'

describe Notification do
  # :userを作成
  let(:user) { FactoryGirl.create(:user) }

  # 事前に@notificationを作成する
  before { @notification = Notification.new(user: user, body: 'Lorem ipsum' * 5, url: '#', read_at: nil) }

  # @notificationをテストの対象とする
  subject { @notification }

  # 属性のテスト
  it { should respond_to(:user) }
  it { should respond_to(:body) }
  it { should respond_to(:url) }
  it { should respond_to(:read_at) }

  # 検証を通過する
  it { should be_valid }

  # userメソッドに応答する
  describe 'user methods' do
    it { should respond_to(:user) }
    it { expect(@notification.user).to eq user }
  end

  # user_idが存在しない場合
  describe 'when user_id is not present' do
    before { @notification.user_id = nil }
    it { should_not be_valid }
  end

  # bodyが存在しない場合
  describe 'when body is not present' do
    before { @notification.body = nil }
    it { should_not be_valid }
  end

  # bodyが存在しない場合
  describe 'when url is not present' do
    before { @notification.url = nil }
    it { should_not be_valid }
  end
end