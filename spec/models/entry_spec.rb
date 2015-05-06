require 'rails_helper'

describe Entry do
  # :userと:categoryを作成
  let(:employer) { FactoryGirl.create(:user) }
  let(:employee) { FactoryGirl.create(:user) }
  let(:category) { FactoryGirl.create(:category) }
  let(:want) { FactoryGirl.create(:want) }
  let(:offering) { FactoryGirl.create(:offering) }

  describe 'Want' do
    # @entryの作成
    before do
      @entry = want.entries.build(
        user: employee
      )
    end

    # entryを対象としたテストを実施
    subject { @entry }

    # 属性に反応するか
    it { should respond_to(:user) }
    it { expect(@entry.user).to eq employee }
    it { should respond_to(:task) }
    it { expect(@entry.task).to eq want }
    it { should respond_to(:hired_at) }
    it { should respond_to(:paid_at) }

    # 適正なデータが検証に通るか
    it { should be_valid }

    # ユーザーIDが設定されていない場合
    describe 'when user_id is not present' do
      before { @entry.user_id = nil }
      it { should_not be_valid }
    end

    # タスクIDが設定されていない場合
    describe 'when task_id is not present' do
      before { @entry.task_id = nil }
      it { should_not be_valid }
    end

    # 採用日時が設定されている場合
    describe 'when hired_at is present' do
      before { @entry.hired_at = 2.day.ago }
      it { should be_valid }
    end

    # 支払日時が設定されている場合
    describe 'when paid_at is present' do
      before { @entry.paid_at = 1.day.ago }
      it { should be_valid }
    end

=begin
    # 既にエントリーされていた場合
    describe 'when already entried' do
      before do
        same_entry = @entry.dup
        same_entry.save
      end

      it { should_not be_valid }
    end
=end
  end

  describe 'Offering' do
    # @entryの作成
    before do
      @entry = offering.entries.build(
        user: employee
      )
    end

    # entryを対象としたテストを実施
    subject { @entry }

    # 属性に反応するか
    it { should respond_to(:user) }
    it { expect(@entry.user).to eq employee }
    it { should respond_to(:task) }
    it { expect(@entry.task).to eq offering }
    it { should respond_to(:hired_at) }
    it { should respond_to(:paid_at) }

    # 適正なデータが検証に通るか
    it { should be_valid }

    # ユーザーIDが設定されていない場合
    describe 'when user_id is not present' do
      before { @entry.user_id = nil }
      it { should_not be_valid }
    end

    # タスクIDが設定されていない場合
    describe 'when task_id is not present' do
      before { @entry.task_id = nil }
      it { should_not be_valid }
    end

    # 採用日時が設定されている場合
    describe 'when hired_at is present' do
      before { @entry.hired_at = 2.day.ago }
      it { should be_valid }
    end

    # 支払日時が設定されている場合
    describe 'when paid_at is present' do
      before { @entry.paid_at = 1.day.ago }
      it { should be_valid }
    end
  end
end
