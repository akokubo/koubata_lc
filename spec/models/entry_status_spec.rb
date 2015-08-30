require 'rails_helper'

describe 'Entry Status' do
  let(:owner) { FactoryGirl.create(:user) }
  let(:user) { FactoryGirl.create(:user) }
  let(:task) { FactoryGirl.create(:task, user: owner) }

  # @entryの作成
  before do
    FactoryGirl.create(:account, user: user)
    FactoryGirl.create(:account, user: owner)
    @entry = FactoryGirl.build(:entry, task: task, user: user, expected_at: Time.now, price: 10)
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

  # 適正なデータが検証に通るか
  it { should be_valid }

  describe "with user's method" do
    context 'entry' do
      it 'change entry count by user entry to task with expected_at and price' do
        expect do
          user.entry!(@entry)
        end.to change { Entry.count }.by(1)
      end

      it 'set entry status by user entry to task with expected_at and price' do
        @entry = user.entry!(@entry)
        expect(@entry.status).to eq 'user committed'
      end

      it 'become commitable by user entry to task with expected_at and price' do
        @entry = user.entry!(@entry)
        expect(@entry.commitable?(user)).to be true
        expect(@entry.commitable?(owner)).to be true
      end

      it 'become cancelable by user entry to task with expected_at and price' do
        @entry = user.entry!(@entry)
        expect(@entry.cancelable?(user)).to be true
        expect(@entry.cancelable?(owner)).to be true
      end

      it 'become not performable by user entry to task with expected_at and price' do
        @entry = user.entry!(@entry)
        expect(@entry.performable?(owner)).to be false
      end

      it 'become not payable by user entry to task with expected_at and price' do
        @entry = user.entry!(@entry)
        expect(@entry.payable?(user)).to be false
      end
    end

    context 'commit on entry' do
      context 'user commit' do
        before do
          @entry = user.entry!(@entry)
          @entry = @entry.user.commit!(@entry, expected_at: @entry.expected_at.ago(2))
        end

        it 'set entry status to user committed by user commit with different expected_at and price' do
          expect(@entry.status).to eq 'user committed'
        end

        it 'become commitable by user commit with different expected_at and price' do
          expect(@entry.commitable?(user)).to be true
          expect(@entry.commitable?(owner)).to be true
        end
      end

      context 'owner commit' do
        before { @entry = user.entry!(@entry) }

        it 'change status to be performed' do
          expect do
            @entry = @entry.owner.commit!(@entry)
          end.to change { @entry.status }.to('to be performed')
        end

        it 'become uncommitable by user' do
          expect do
            @entry = @entry.owner.commit!(@entry)
          end.to change { @entry.commitable?(user) }.from(true).to(false)
        end

        it 'become uncommitable by owner' do
          expect do
            @entry = @entry.owner.commit!(@entry)
          end.to change { @entry.commitable?(owner) }.from(true).to(false)
        end

        it 'become performable' do
          expect do
            @entry = @entry.owner.commit!(@entry)
          end.to change { @entry.performable?(owner) }.from(false).to(true)
        end

        it 'is cancelable' do
          @entry = @entry.owner.commit!(@entry)
          expect(@entry.cancelable?(user)).to be true
          expect(@entry.cancelable?(owner)).to be true
        end

        it 'is not payable' do
          @entry = @entry.owner.commit!(@entry)
          expect(@entry.payable?(user)).to be false
        end

        context 'with different expected_at' do
          before { @entry = user.entry!(@entry) }

          it 'change status to owner committed' do
            expect do
              @entry = @entry.owner.commit!(@entry, expected_at: @entry.expected_at.ago(2))
            end.to change { @entry.status }.to('owner committed')
          end

          it 'is commitable by user' do
            @entry = @entry.owner.commit!(@entry, expected_at: @entry.expected_at.ago(2))
            expect(@entry.commitable?(user)).to be true
          end

          it 'is commitable by owner' do
            @entry = @entry.owner.commit!(@entry, expected_at: @entry.expected_at.ago(2))
            expect(@entry.commitable?(owner)).to be true
          end

          it 'is cancelable by user' do
            @entry = @entry.owner.commit!(@entry, expected_at: @entry.expected_at.ago(2))
            expect(@entry.cancelable?(user)).to be true
          end

          it 'is cancelable by user' do
            @entry = @entry.owner.commit!(@entry, expected_at: @entry.expected_at.ago(2))
            expect(@entry.cancelable?(owner)).to be true
          end

          it 'is not performable' do
            @entry = @entry.owner.commit!(@entry, expected_at: @entry.expected_at.ago(2))
            expect(@entry.performable?(owner)).to be false
          end

          it 'is not payable' do
            @entry = @entry.owner.commit!(@entry, expected_at: @entry.expected_at.ago(2))
            expect(@entry.payable?(user)).to be false
          end
        end

        context 'with different price' do
          before { @entry = user.entry!(@entry) }

          it 'change status to owner committed' do
            expect do
              @entry = @entry.owner.commit!(@entry, price: @entry.price + 1)
            end.to change { @entry.status }.to('owner committed')
          end

          it 'is commitable by user' do
            @entry = @entry.owner.commit!(@entry, price: @entry.price + 1)
            expect(@entry.commitable?(user)).to be true
          end

          it 'is commitable by owner' do
            @entry = @entry.owner.commit!(@entry, price: @entry.price + 1)
            expect(@entry.commitable?(owner)).to be true
          end

          it 'is cancelable by user' do
            @entry = @entry.owner.commit!(@entry, price: @entry.price + 1)
            expect(@entry.cancelable?(user)).to be true
          end

          it 'is cancelable by owner' do
            @entry = @entry.owner.commit!(@entry, price: @entry.price + 1)
            expect(@entry.cancelable?(owner)).to be true
          end

          it 'is not performable' do
            @entry = @entry.owner.commit!(@entry, price: @entry.price + 1)
            expect(@entry.performable?(owner)).to be false
          end

          it 'is not payable' do
            @entry = @entry.owner.commit!(@entry, price: @entry.price + 1)
            expect(@entry.payable?(user)).to be false
          end
        end
      end
    end

    context 'user commit on owner committed' do
      before do
        @entry = user.entry!(@entry)
        @entry = @entry.owner.commit!(@entry, price: @entry.price + 1)
      end

      it 'change status to committed' do
        expect do
          @entry = @entry.user.commit!(@entry)
        end.to change { @entry.status }.to('to be performed')
      end

      it 'become uncommitable by user' do
        expect do
          @entry = @entry.user.commit!(@entry)
        end.to change { @entry.commitable?(user) }.from(true).to(false)
      end

      it 'become uncommitable by owner' do
        expect do
          @entry = @entry.user.commit!(@entry)
        end.to change { @entry.commitable?(owner) }.from(true).to(false)
      end

      it 'is cancelable by user' do
        @entry = @entry.user.commit!(@entry)
        expect(@entry.cancelable?(user)).to be true
      end

      it 'is cancelable by owner' do
        @entry = @entry.user.commit!(@entry)
        expect(@entry.cancelable?(owner)).to be true
      end

      it 'become performable' do
        expect do
          @entry = @entry.user.commit!(@entry)
        end.to change { @entry.performable?(owner) }.from(false).to(true)
      end

      it 'is not payable' do
        @entry = @entry.user.commit!(@entry)
        expect(@entry.payable?(user)).to be false
      end

      context 'with different expected_at' do
        before do
          @entry = user.entry!(@entry)
          @entry = @entry.owner.commit!(@entry, price: @entry.price + 1)
        end

        it 'change status to user committed' do
          expect do
            @entry = @entry.user.commit!(@entry, price: @entry.price + 1)
          end.to change { @entry.status }.to('user committed')
        end

        it 'is commitable by user' do
          @entry = @entry.user.commit!(@entry, price: @entry.price + 1)
          expect(@entry.commitable?(user)).to be true
        end

        it 'is commitable by owner' do
          @entry = @entry.user.commit!(@entry, price: @entry.price + 1)
          expect(@entry.commitable?(owner)).to be true
        end

        it 'is cancelable by user' do
          @entry = @entry.user.commit!(@entry, price: @entry.price + 1)
          expect(@entry.cancelable?(user)).to be true
        end

        it 'is cancelable by owner' do
          @entry = @entry.user.commit!(@entry, price: @entry.price + 1)
          expect(@entry.cancelable?(owner)).to be true
        end

        it 'is not performable' do
          @entry = @entry.user.commit!(@entry, price: @entry.price + 1)
          expect(@entry.performable?(owner)).to be false
        end

        it 'is not payable' do
          @entry = @entry.user.commit!(@entry, price: @entry.price + 1)
          expect(@entry.payable?(user)).to be false
        end
      end

      context 'with different price' do
        before do
          @entry = user.entry!(@entry)
          @entry = @entry.owner.commit!(@entry, price: @entry.price + 1)
        end

        it 'change status to user committed' do
          expect do
            @entry = @entry.user.commit!(@entry, expected_at: @entry.expected_at.ago(1))
          end.to change { @entry.status }.to('user committed')
        end

        it 'is commitable by user' do
          @entry = @entry.user.commit!(@entry, expected_at: @entry.expected_at.ago(1))
          expect(@entry.commitable?(user)).to be true
        end

        it 'is commitable by owner' do
          @entry = @entry.user.commit!(@entry, expected_at: @entry.expected_at.ago(1))
          expect(@entry.commitable?(owner)).to be true
        end

        it 'is cancelable by user' do
          @entry = @entry.user.commit!(@entry, expected_at: @entry.expected_at.ago(1))
          expect(@entry.cancelable?(user)).to be true
        end

        it 'is cancelable by owner' do
          @entry = @entry.user.commit!(@entry, expected_at: @entry.expected_at.ago(1))
          expect(@entry.cancelable?(owner)).to be true
        end

        it 'is not performable' do
          @entry = @entry.user.commit!(@entry, expected_at: @entry.expected_at.ago(1))
          expect(@entry.performable?(owner)).to be false
        end

        it 'is not payable' do
          @entry = @entry.user.commit!(@entry, expected_at: @entry.expected_at.ago(1))
          expect(@entry.payable?(user)).to be false
        end
      end
    end

    context 'cancel' do
      context 'owner cancel on entry' do
        before { @entry = user.entry!(@entry) }
        it 'change status to owner canceled' do
          expect do
            @entry.owner.cancel!(@entry)
          end.to change { @entry.status }.to('owner canceled')
        end

        it 'become uncommitable by user' do
          expect do
            @entry.owner.cancel!(@entry)
          end.to change { @entry.commitable?(user) }.from(true).to(false)
        end

        it 'become uncommitable by owner' do
          expect do
            @entry.owner.cancel!(@entry)
          end.to change { @entry.commitable?(owner) }.from(true).to(false)
        end

        it 'become uncancelable by user' do
          expect do
            @entry.owner.cancel!(@entry)
          end.to change { @entry.cancelable?(user) }.from(true).to(false)
        end

        it 'become uncancelable by owner' do
          expect do
            @entry.owner.cancel!(@entry)
          end.to change { @entry.cancelable?(owner) }.from(true).to(false)
        end

        it 'is unperformable' do
          @entry.owner.cancel!(@entry)
          expect(@entry.performable?(owner)).to be false
        end

        it 'is unpayable' do
          @entry.owner.cancel!(@entry)
          expect(@entry.payable?(user)).to be false
        end
      end

      context 'user cancel on entry' do
        before { @entry = user.entry!(@entry) }
        it 'change status to user canceled' do
          expect do
            @entry.user.cancel!(@entry)
          end.to change { @entry.status }.to('user canceled')
        end

        it 'become uncommitable by user' do
          expect do
            @entry.user.cancel!(@entry)
          end.to change { @entry.commitable?(user) }.from(true).to(false)
        end

        it 'become uncommitable by owner' do
          expect do
            @entry.user.cancel!(@entry)
          end.to change { @entry.commitable?(owner) }.from(true).to(false)
        end

        it 'become uncancelable by user' do
          expect do
            @entry.user.cancel!(@entry)
          end.to change { @entry.cancelable?(user) }.from(true).to(false)
        end

        it 'become uncancelable by owner' do
          expect do
            @entry.user.cancel!(@entry)
          end.to change { @entry.cancelable?(owner) }.from(true).to(false)
        end

        it 'is unperformable' do
          @entry.user.cancel!(@entry)
          expect(@entry.performable?(owner)).to be false
        end

        it 'is unpayable' do
          @entry.user.cancel!(@entry)
          expect(@entry.payable?(user)).to be false
        end
      end

      context 'owner cancel on committed' do
        before do
          @entry = user.entry!(@entry)
          @entry = owner.commit!(@entry)
        end

        it 'change status to owner canceled' do
          expect do
            @entry.owner.cancel!(@entry)
          end.to change { @entry.status }.to('owner canceled')
        end

        it 'is uncommitable by user' do
          @entry.owner.cancel!(@entry)
          expect(@entry.commitable?(user)).to be false
        end

        it 'is uncommitable by owner' do
          @entry.owner.cancel!(@entry)
          expect(@entry.commitable?(owner)).to be false
        end

        it 'become uncancelable by user' do
          expect do
            @entry.owner.cancel!(@entry)
          end.to change { @entry.cancelable?(user) }.from(true).to(false)
        end

        it 'become uncancelable by owner' do
          expect do
            @entry.owner.cancel!(@entry)
          end.to change { @entry.cancelable?(owner) }.from(true).to(false)
        end

        it 'is unperformable' do
          @entry.owner.cancel!(@entry)
          expect(@entry.performable?(owner)).to be false
        end

        it 'is unpayable' do
          @entry.owner.cancel!(@entry)
          expect(@entry.payable?(user)).to be false
        end
      end

      context 'user cancel on committed' do
        before do
          @entry = user.entry!(@entry)
          @entry = owner.commit!(@entry)
        end

        it 'change status to user canceled' do
          expect do
            @entry.user.cancel!(@entry)
          end.to change { @entry.status }.to('user canceled')
        end

        it 'is uncommitable by user' do
          @entry.user.cancel!(@entry)
          expect(@entry.commitable?(user)).to be false
        end

        it 'is uncommitable by owner' do
          @entry.user.cancel!(@entry)
          expect(@entry.commitable?(owner)).to be false
        end

        it 'become uncancelable by user' do
          expect do
            @entry.user.cancel!(@entry)
          end.to change { @entry.cancelable?(user) }.from(true).to(false)
        end

        it 'become uncancelable by owner' do
          expect do
            @entry.user.cancel!(@entry)
          end.to change { @entry.cancelable?(owner) }.from(true).to(false)
        end

        it 'is unperformable' do
          @entry.user.cancel!(@entry)
          expect(@entry.performable?(owner)).to be false
        end

        it 'is unpayable' do
          @entry.user.cancel!(@entry)
          expect(@entry.payable?(user)).to be false
        end
      end

      context 'cancel on canlceled' do
        before do
          @entry = user.entry!(@entry)
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
