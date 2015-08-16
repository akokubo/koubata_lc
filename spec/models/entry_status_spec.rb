require 'rails_helper'

describe 'Entry Status' do
  let(:owner) { FactoryGirl.create(:user) }
  let(:user) { FactoryGirl.create(:user) }
  let(:task) { FactoryGirl.create(:task, user: owner) }

  # @entryの作成
  before do
    FactoryGirl.create(:account, user: user)
    FactoryGirl.create(:account, user: owner)
    @entry = FactoryGirl.build(:entry, task: task, user: user)
  end

  subject { @entry }

  # 属性に反応するか
  it { should respond_to(:owner_committed_at) }
  it { should respond_to(:user_committed_at) }
  it { should respond_to(:paid_at) }
  it { should respond_to(:expected_at) }
  it { should respond_to(:performed_at) }
  it { should respond_to(:owner_canceled_at) }
  it { should respond_to(:user_canceled_at) }

  # メソッドに反応するか
  it { should respond_to(:commitable?) }
  it { should respond_to(:performable?) }
  it { should respond_to(:payable?) }
  it { should respond_to(:cancelable?) }
  it { should respond_to(:status) }
  it { should respond_to(:conditions_change?) }
=begin
  it { should respond_to(:committed?) }
  it { should respond_to(:owner_committed?) }
  it { should respond_to(:user_committed?) }
  it { should respond_to(:performed?) }
  it { should respond_to(:paid?) }
  it { should respond_to(:canceled?) }
  it { should respond_to(:owner_canceled?) }
  it { should respond_to(:user_canceled?) }
=end

  # 適正なデータが検証に通るか
  it { should be_valid }

  describe 'with direct datetime assignment' do
=begin
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

    # 未支払
    describe 'before paid' do
      before do
        @entry.paid_at = nil
      end
      it { expect(@entry.paid?).to eq false }
    end

    # 支払済
    describe 'when paid' do
      before do
        @entry.paid_at = Time.now
      end
      it { expect(@entry.status).to eq 'closed' }
      it { expect(@entry.paid?).to eq true }
    end

    # 未実施
    describe 'before performed' do
      before do
        @entry.performed_at = nil
      end
      it { expect(@entry.performed?).to eq false }
    end

    # 実行済
    describe 'when performed' do
      before do
        @entry.performed_at = Time.now
      end
      it { expect(@entry.status).to eq 'to be paid' }
      it { expect(@entry.performed?).to eq true }
    end

    # オーナーがキャンセルしていない/ユーザーがキャンセルしていない
    describe 'when both not canceled' do
      before do
        @entry.owner_canceled_at = nil
        @entry.user_canceled_at = nil
      end
      it { expect(@entry.status).not_to eq 'owner canceled' }
      it { expect(@entry.status).not_to eq 'user canceled' }
      it { expect(@entry.canceled?).to eq false }
    end

    # オーナーがキャンセルしていない/ユーザーがキャンセル
    describe 'when owner canceled' do
      before do
        @entry.owner_canceled_at = nil
        @entry.user_canceled_at = Time.now
      end
      it { expect(@entry.status).to eq 'user canceled' }
      it { expect(@entry.canceled?).to eq true }
    end

    # オーナーがキャンセル/ユーザーがキャンセルしていない
    describe 'when user canceled' do
      before do
        @entry.owner_canceled_at = Time.now
        @entry.user_canceled_at = nil
      end
      it { expect(@entry.status).to eq 'owner canceled' }
      it { expect(@entry.canceled?).to eq true }
    end

    # オーナーがコミットしていない/ユーザーがコミットしていない
    describe 'when both uncommitted' do
      before do
        @entry.owner_committed_at = nil
        @entry.user_committed_at = nil
      end
      it { expect(@entry.status).to eq 'to be committed' }
      it { expect(@entry.committed?).to eq false }
    end

    # オーナーがコミットしていない/ユーザーがコミット
    describe 'when owner uncommitted' do
      before do
        @entry.owner_committed_at = nil
        @entry.user_committed_at = Time.now
      end
      it { expect(@entry.status).to eq 'user committed' }
      it { expect(@entry.committed?).to eq false }
    end

    # オーナーがコミット/ユーザーがコミットしていない
    describe 'when user uncommitted' do
      before do
        @entry.owner_committed_at = Time.now
        @entry.user_committed_at = nil
      end
      it { expect(@entry.status).to eq 'owner committed' }
      it { expect(@entry.committed?).to eq false }
    end

    # オーナーがコミット/ユーザーがコミット
    describe 'when user uncommitted' do
      before do
        @entry.owner_committed_at = Time.now
        @entry.user_committed_at = Time.now
      end
      it { expect(@entry.status).to eq 'to be performed' }
      it { expect(@entry.committed?).to eq true }
    end
=end
  end

  describe "with user's method" do
    context 'entry' do
      it 'change entry count by user entry to task with expected_at and price' do
        expect do
          user.entry!(task, expected_at: Time.now, price: 10)
        end.to change { Entry.count }.by(1)
      end

      it 'set entry status by user entry to task with expected_at and price' do
        @entry = user.entry!(task, expected_at: Time.now, price: 10)
        expect(@entry.status).to eq 'user committed'
      end

      it 'become commitable by user entry to task with expected_at and price' do
        @entry = user.entry!(task, expected_at: Time.now, price: 10)
        expect(@entry.commitable?).to be true
      end

      it 'become cancelable by user entry to task with expected_at and price' do
        @entry = user.entry!(task, expected_at: Time.now, price: 10)
        expect(@entry.cancelable?).to be true
      end

      it 'become not performable by user entry to task with expected_at and price' do
        @entry = user.entry!(task, expected_at: Time.now, price: 10)
        expect(@entry.performable?).to be false
      end

      it 'become not payable by user entry to task with expected_at and price' do
        @entry = user.entry!(task, expected_at: Time.now, price: 10)
        expect(@entry.payable?).to be false
      end
    end

    context 'commit on entry' do
      context 'user commit' do
        before do
          @entry = user.entry!(task, expected_at: Time.now, price: 10)
          @entry = @entry.user.commit!(@entry, expected_at: @entry.expected_at.ago(2))
        end

        it 'set entry status to user committed by user commit with different expected_at and price' do
          expect(@entry.status).to eq 'user committed'
        end

        it 'become commitable by user commit with different expected_at and price' do
          expect(@entry.commitable?).to be true
        end
      end

      context 'owner commit' do
        before { @entry = user.entry!(task, expected_at: Time.now, price: 10) }

        it 'change status to be performed' do
          expect do
            @entry = @entry.owner.commit!(@entry)
          end.to change { @entry.status }.to('to be performed')
        end

        it 'become uncommitable' do
          expect do
            @entry = @entry.owner.commit!(@entry)
          end.to change { @entry.commitable? }.from(true).to(false)
        end

        it 'become performable' do
          expect do
            @entry = @entry.owner.commit!(@entry)
          end.to change { @entry.performable? }.from(false).to(true)
        end

        it 'is cancelable' do
          @entry = @entry.owner.commit!(@entry)
          expect(@entry.cancelable?).to be true
        end

        it 'is not payable' do
          @entry = @entry.owner.commit!(@entry)
          expect(@entry.payable?).to be false
        end

        context 'with different expected_at' do
          before { @entry = user.entry!(task, expected_at: Time.now, price: 10) }

          it 'change status to owner committed' do
            expect do
              @entry = @entry.owner.commit!(@entry, expected_at: @entry.expected_at.ago(2))
            end.to change { @entry.status }.to('owner committed')
          end

          it 'is commitable' do
            @entry = @entry.owner.commit!(@entry, expected_at: @entry.expected_at.ago(2))
            expect(@entry.commitable?).to be true
          end

          it 'is cancelable' do
            @entry = @entry.owner.commit!(@entry, expected_at: @entry.expected_at.ago(2))
            expect(@entry.cancelable?).to be true
          end

          it 'is not performable' do
            @entry = @entry.owner.commit!(@entry, expected_at: @entry.expected_at.ago(2))
            expect(@entry.performable?).to be false
          end

          it 'is not payable' do
            @entry = @entry.owner.commit!(@entry, expected_at: @entry.expected_at.ago(2))
            expect(@entry.payable?).to be false
          end
        end

        context 'with different price' do
          before { @entry = user.entry!(task, expected_at: Time.now, price: 10) }

          it 'change status to owner committed' do
            expect do
              @entry = @entry.owner.commit!(@entry, price: @entry.price + 1)
            end.to change { @entry.status }.to('owner committed')
          end

          it 'is commitable' do
            @entry = @entry.owner.commit!(@entry, price: @entry.price + 1)
            expect(@entry.commitable?).to be true
          end

          it 'is cancelable' do
            @entry = @entry.owner.commit!(@entry, price: @entry.price + 1)
            expect(@entry.cancelable?).to be true
          end

          it 'is not performable' do
            @entry = @entry.owner.commit!(@entry, price: @entry.price + 1)
            expect(@entry.performable?).to be false
          end

          it 'is not payable' do
            @entry = @entry.owner.commit!(@entry, price: @entry.price + 1)
            expect(@entry.payable?).to be false
          end
        end
      end
    end

    context 'user commit on owner committed' do
      before do
        @entry = user.entry!(task, expected_at: Time.now, price: 10)
        @entry = @entry.owner.commit!(@entry, price: @entry.price + 1)
      end

      it 'change status to committed' do
        expect do
          @entry = @entry.user.commit!(@entry)
        end.to change { @entry.status }.to('to be performed')
      end

      it 'become uncommitable' do
        expect do
          @entry = @entry.user.commit!(@entry)
        end.to change { @entry.commitable? }.from(true).to(false)
      end

      it 'become performable' do
        expect do
          @entry = @entry.user.commit!(@entry)
        end.to change { @entry.performable? }.from(false).to(true)
      end

      it 'is cancelable' do
        @entry = @entry.user.commit!(@entry)
        expect(@entry.cancelable?).to be true
      end

      it 'is not payable' do
        @entry = @entry.user.commit!(@entry)
        expect(@entry.payable?).to be false
      end

      context 'with different expected_at' do
        before do
          @entry = user.entry!(task, expected_at: Time.now, price: 10)
          @entry = @entry.owner.commit!(@entry, price: @entry.price + 1)
        end

        it 'change status to user committed' do
          expect do
            @entry = @entry.user.commit!(@entry, price: @entry.price + 1)
          end.to change { @entry.status }.to('user committed')
        end

        it 'is commitable' do
          @entry = @entry.user.commit!(@entry, price: @entry.price + 1)
          expect(@entry.commitable?).to be true
        end

        it 'is cancelable' do
          @entry = @entry.user.commit!(@entry, price: @entry.price + 1)
          expect(@entry.cancelable?).to be true
        end

        it 'is not performable' do
          @entry = @entry.user.commit!(@entry, price: @entry.price + 1)
          expect(@entry.performable?).to be false
        end

        it 'is not payable' do
          @entry = @entry.user.commit!(@entry, price: @entry.price + 1)
          expect(@entry.payable?).to be false
        end
      end

      context 'with different price' do
        before do
          @entry = user.entry!(task, expected_at: Time.now, price: 10)
          @entry = @entry.owner.commit!(@entry, price: @entry.price + 1)
        end

        it 'change status to user committed' do
          expect do
            @entry = @entry.user.commit!(@entry, expected_at: @entry.expected_at.ago(1))
          end.to change { @entry.status }.to('user committed')
        end

        it 'is commitable' do
          @entry = @entry.user.commit!(@entry, expected_at: @entry.expected_at.ago(1))
          expect(@entry.commitable?).to be true
        end

        it 'is cancelable' do
          @entry = @entry.user.commit!(@entry, expected_at: @entry.expected_at.ago(1))
          expect(@entry.cancelable?).to be true
        end

        it 'is not performable' do
          @entry = @entry.user.commit!(@entry, expected_at: @entry.expected_at.ago(1))
          expect(@entry.performable?).to be false
        end

        it 'is not payable' do
          @entry = @entry.user.commit!(@entry, expected_at: @entry.expected_at.ago(1))
          expect(@entry.payable?).to be false
        end
      end
    end
    context 'cancel' do
      context 'owner cancel on entry' do
        before { @entry = user.entry!(task, expected_at: Time.now, price: 10) }
        it 'change status to owner canceled' do
          expect do
            @entry.owner.cancel!(@entry)
          end.to change { @entry.status }.to('owner canceled')
        end

        it 'become uncommitable' do
          expect do
            @entry.owner.cancel!(@entry)
          end.to change { @entry.commitable? }.from(true).to(false)
        end

        it 'become uncancelable' do
          expect do
            @entry.owner.cancel!(@entry)
          end.to change { @entry.cancelable? }.from(true).to(false)
        end

        it 'is unperformable' do
          @entry.owner.cancel!(@entry)
          expect(@entry.performable?).to be false
        end

        it 'is unpayable' do
          @entry.owner.cancel!(@entry)
          expect(@entry.payable?).to be false
        end
      end

      context 'user cancel on entry' do
        before { @entry = user.entry!(task, expected_at: Time.now, price: 10) }
        it 'change status to user canceled' do
          expect do
            @entry.user.cancel!(@entry)
          end.to change { @entry.status }.to('user canceled')
        end

        it 'become uncommitable' do
          expect do
            @entry.user.cancel!(@entry)
          end.to change { @entry.commitable? }.from(true).to(false)
        end

        it 'become uncancelable' do
          expect do
            @entry.user.cancel!(@entry)
          end.to change { @entry.cancelable? }.from(true).to(false)
        end

        it 'is unperformable' do
          @entry.user.cancel!(@entry)
          expect(@entry.performable?).to be false
        end

        it 'is unpayable' do
          @entry.user.cancel!(@entry)
          expect(@entry.payable?).to be false
        end
      end

      context 'owner cancel on committed' do
        before do
          @entry = user.entry!(task, expected_at: Time.now, price: 10)
          @entry = owner.commit!(@entry)
        end

        it 'change status to owner canceled' do
          expect do
            @entry.owner.cancel!(@entry)
          end.to change { @entry.status }.to('owner canceled')
        end

        it 'is uncommitable' do
          @entry.owner.cancel!(@entry)
          expect(@entry.commitable?).to be false
        end

        it 'become uncancelable' do
          expect do
            @entry.owner.cancel!(@entry)
          end.to change { @entry.cancelable? }.from(true).to(false)
        end

        it 'is unperformable' do
          @entry.owner.cancel!(@entry)
          expect(@entry.performable?).to be false
        end

        it 'is unpayable' do
          @entry.owner.cancel!(@entry)
          expect(@entry.payable?).to be false
        end
      end

      context 'user cancel on committed' do
        before do
          @entry = user.entry!(task, expected_at: Time.now, price: 10)
          @entry = owner.commit!(@entry)
        end

        it 'change status to user canceled' do
          expect do
            @entry.user.cancel!(@entry)
          end.to change { @entry.status }.to('user canceled')
        end

        it 'is uncommitable' do
          @entry.user.cancel!(@entry)
          expect(@entry.commitable?).to be false
        end

        it 'become uncancelable' do
          expect do
            @entry.user.cancel!(@entry)
          end.to change { @entry.cancelable? }.from(true).to(false)
        end

        it 'is unperformable' do
          @entry.user.cancel!(@entry)
          expect(@entry.performable?).to be false
        end

        it 'is unpayable' do
          @entry.user.cancel!(@entry)
          expect(@entry.payable?).to be false
        end
      end

      context 'cancel on canlceled' do
        before do
          @entry = user.entry!(task, expected_at: Time.now, price: 10)
          @entry = @entry.owner.cancel!(@entry)
        end

        it 'raise RuntimeError with owner canceled' do
          expect do
            owner.cancel!(@entry)
          end.to raise_error(RuntimeError)
        end

        it 'raise RuntimeError with owner canceled' do
          expect do
            user.cancel!(@entry)
          end.to raise_error(RuntimeError)
        end
      end
    end
  end
end
