require 'rails_helper'

describe 'Entry Status' do
  let(:owner) { FactoryGirl.create(:user) }
  let(:contractor) { FactoryGirl.create(:user) }
  let(:task) { FactoryGirl.create(:task, user: owner) }

  # @entryの作成
  before do
    FactoryGirl.create(:account, user: contractor)
    FactoryGirl.create(:account, user: owner)
    @entry = FactoryGirl.build(
      :entry,
      title: task.title,
      description: task.description,
      prior_price: task.price,
      expired_at: task.expired_at,
      category: task.category,
      owner: owner,
      contractor: contractor,
      expected_at: Time.now,
      price: 10
    )
  end

  subject { @entry }

  # 属性に反応するか
  it { should respond_to(:owner_committed_at) }
  it { should respond_to(:contractor_committed_at) }
  it { should respond_to(:paid_at) }
  it { should respond_to(:expected_at) }
  it { should respond_to(:performed_at) }
  it { should respond_to(:owner_canceled_at) }
  it { should respond_to(:contractor_canceled_at) }

  # メソッドに反応するか
  it { should respond_to(:commitable?) }
  it { should respond_to(:performable?) }
  it { should respond_to(:payable?) }
  it { should respond_to(:cancelable?) }
  it { should respond_to(:status) }
  it { should respond_to(:conditions_change?) }

  # 適正なデータが検証に通るか
  it { should be_valid }

  describe "with contractor's method" do
    context 'entry' do
      it 'change entry count by contractor entry to task with expected_at and price' do
        expect do
          contractor.entry!(@entry)
        end.to change { Entry.count }.by(1)
      end

      it 'set entry status by contractor entry to task with expected_at and price' do
        @entry = contractor.entry!(@entry)
        expect(@entry.status).to eq 'contractor committed'
      end

      it 'become commitable by contractor entry to task with expected_at and price' do
        @entry = contractor.entry!(@entry)
        expect(@entry.commitable?(contractor)).to be true
        expect(@entry.commitable?(owner)).to be true
      end

      it 'become cancelable by contractor entry to task with expected_at and price' do
        @entry = contractor.entry!(@entry)
        expect(@entry.cancelable?(contractor)).to be true
        expect(@entry.cancelable?(owner)).to be true
      end

      it 'become not performable by contractor entry to task with expected_at and price' do
        @entry = contractor.entry!(@entry)
        expect(@entry.performable?(owner)).to be false
      end

      it 'become not payable by contractor entry to task with expected_at and price' do
        @entry = contractor.entry!(@entry)
        expect(@entry.payable?(contractor)).to be false
      end
    end

    context 'commit on entry' do
      context 'contractor commit' do
        before do
          @entry = contractor.entry!(@entry)
          @entry = @entry.contractor.commit!(@entry, expected_at: @entry.expected_at.ago(2))
        end

        it 'set entry status to contractor committed by contractor commit with different expected_at and price' do
          expect(@entry.status).to eq 'contractor committed'
        end

        it 'become commitable by contractor commit with different expected_at and price' do
          expect(@entry.commitable?(contractor)).to be true
          expect(@entry.commitable?(owner)).to be true
        end
      end

      context 'owner commit' do
        before { @entry = contractor.entry!(@entry) }

        it 'change status to be performed' do
          expect do
            @entry = @entry.owner.commit!(@entry)
          end.to change { @entry.status }.to('to be performed')
        end

        it 'become uncommitable by contractor' do
          expect do
            @entry = @entry.owner.commit!(@entry)
          end.to change { @entry.commitable?(contractor) }.from(true).to(false)
        end

        it 'become uncommitable by owner' do
          expect do
            @entry = @entry.owner.commit!(@entry)
          end.to change { @entry.commitable?(owner) }.from(true).to(false)
        end

        it 'become performable' do
          expect do
            @entry = @entry.owner.commit!(@entry)
          end.to change { @entry.performable?(contractor) }.from(false).to(true)
        end

        it 'is cancelable' do
          @entry = @entry.owner.commit!(@entry)
          expect(@entry.cancelable?(contractor)).to be true
          expect(@entry.cancelable?(owner)).to be true
        end

        it 'is not payable' do
          @entry = @entry.owner.commit!(@entry)
          expect(@entry.payable?(contractor)).to be false
        end

        context 'with different expected_at' do
          it 'change status to owner committed' do
            expect do
              @entry = @entry.owner.commit!(@entry, expected_at: @entry.expected_at.ago(2))
            end.to change { @entry.status }.to('owner committed')
          end

          it 'is commitable by contractor' do
            @entry = @entry.owner.commit!(@entry, expected_at: @entry.expected_at.ago(2))
            expect(@entry.commitable?(contractor)).to be true
          end

          it 'is commitable by owner' do
            @entry = @entry.owner.commit!(@entry, expected_at: @entry.expected_at.ago(2))
            expect(@entry.commitable?(owner)).to be true
          end

          it 'is cancelable by contractor' do
            @entry = @entry.owner.commit!(@entry, expected_at: @entry.expected_at.ago(2))
            expect(@entry.cancelable?(contractor)).to be true
          end

          it 'is cancelable by contractor' do
            @entry = @entry.owner.commit!(@entry, expected_at: @entry.expected_at.ago(2))
            expect(@entry.cancelable?(owner)).to be true
          end

          it 'is not performable' do
            @entry = @entry.owner.commit!(@entry, expected_at: @entry.expected_at.ago(2))
            expect(@entry.performable?(owner)).to be false
          end

          it 'is not payable' do
            @entry = @entry.owner.commit!(@entry, expected_at: @entry.expected_at.ago(2))
            expect(@entry.payable?(contractor)).to be false
          end
        end

        context 'with different price' do
          it 'change status to owner committed' do
            expect do
              @entry = @entry.owner.commit!(@entry, price: @entry.price + 1)
            end.to change { @entry.status }.to('owner committed')
          end

          it 'is commitable by contractor' do
            @entry = @entry.owner.commit!(@entry, price: @entry.price + 1)
            expect(@entry.commitable?(contractor)).to be true
          end

          it 'is commitable by owner' do
            @entry = @entry.owner.commit!(@entry, price: @entry.price + 1)
            expect(@entry.commitable?(owner)).to be true
          end

          it 'is cancelable by contractor' do
            @entry = @entry.owner.commit!(@entry, price: @entry.price + 1)
            expect(@entry.cancelable?(contractor)).to be true
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
            expect(@entry.payable?(contractor)).to be false
          end
        end
      end
    end

    context 'contractor commit on owner committed' do
      before do
        @entry = contractor.entry!(@entry)
        @entry = @entry.owner.commit!(@entry, price: @entry.price + 1)
      end

      it 'change status to committed' do
        expect do
          @entry = @entry.contractor.commit!(@entry)
        end.to change { @entry.status }.to('to be performed')
      end

      it 'become uncommitable by contractor' do
        expect do
          @entry = @entry.contractor.commit!(@entry)
        end.to change { @entry.commitable?(contractor) }.from(true).to(false)
      end

      it 'become uncommitable by owner' do
        expect do
          @entry = @entry.contractor.commit!(@entry)
        end.to change { @entry.commitable?(owner) }.from(true).to(false)
      end

      it 'is cancelable by contractor' do
        @entry = @entry.contractor.commit!(@entry)
        expect(@entry.cancelable?(contractor)).to be true
      end

      it 'is cancelable by owner' do
        @entry = @entry.contractor.commit!(@entry)
        expect(@entry.cancelable?(owner)).to be true
      end

      it 'become performable' do
        expect do
          @entry = @entry.contractor.commit!(@entry)
        end.to change { @entry.performable?(contractor) }.from(false).to(true)
      end

      it 'is not payable' do
        @entry = @entry.contractor.commit!(@entry)
        expect(@entry.payable?(contractor)).to be false
      end

      context 'with different expected_at' do
        before { @entry = @entry.owner.commit!(@entry, price: @entry.price + 1) }

        it 'change status to contractor committed' do
          expect do
            @entry = @entry.contractor.commit!(@entry, price: @entry.price + 1)
          end.to change { @entry.status }.to('contractor committed')
        end

        it 'is commitable by contractor' do
          @entry = @entry.contractor.commit!(@entry, price: @entry.price + 1)
          expect(@entry.commitable?(contractor)).to be true
        end

        it 'is commitable by owner' do
          @entry = @entry.contractor.commit!(@entry, price: @entry.price + 1)
          expect(@entry.commitable?(owner)).to be true
        end

        it 'is cancelable by contractor' do
          @entry = @entry.contractor.commit!(@entry, price: @entry.price + 1)
          expect(@entry.cancelable?(contractor)).to be true
        end

        it 'is cancelable by owner' do
          @entry = @entry.contractor.commit!(@entry, price: @entry.price + 1)
          expect(@entry.cancelable?(owner)).to be true
        end

        it 'is not performable' do
          @entry = @entry.contractor.commit!(@entry, price: @entry.price + 1)
          expect(@entry.performable?(owner)).to be false
        end

        it 'is not payable' do
          @entry = @entry.contractor.commit!(@entry, price: @entry.price + 1)
          expect(@entry.payable?(contractor)).to be false
        end
      end

      context 'with different price' do
        before { @entry = @entry.owner.commit!(@entry, price: @entry.price + 1) }

        it 'change status to contractor committed' do
          expect do
            @entry = @entry.contractor.commit!(@entry, expected_at: @entry.expected_at.ago(1))
          end.to change { @entry.status }.to('contractor committed')
        end

        it 'is commitable by contractor' do
          @entry = @entry.contractor.commit!(@entry, expected_at: @entry.expected_at.ago(1))
          expect(@entry.commitable?(contractor)).to be true
        end

        it 'is commitable by owner' do
          @entry = @entry.contractor.commit!(@entry, expected_at: @entry.expected_at.ago(1))
          expect(@entry.commitable?(owner)).to be true
        end

        it 'is cancelable by contractor' do
          @entry = @entry.contractor.commit!(@entry, expected_at: @entry.expected_at.ago(1))
          expect(@entry.cancelable?(contractor)).to be true
        end

        it 'is cancelable by owner' do
          @entry = @entry.contractor.commit!(@entry, expected_at: @entry.expected_at.ago(1))
          expect(@entry.cancelable?(owner)).to be true
        end

        it 'is not performable' do
          @entry = @entry.contractor.commit!(@entry, expected_at: @entry.expected_at.ago(1))
          expect(@entry.performable?(owner)).to be false
        end

        it 'is not payable' do
          @entry = @entry.contractor.commit!(@entry, expected_at: @entry.expected_at.ago(1))
          expect(@entry.payable?(contractor)).to be false
        end
      end
    end

    context 'cancel' do
      context 'owner cancel on entry' do
        before { @entry = contractor.entry!(@entry) }
        it 'change status to owner canceled' do
          expect do
            @entry.owner.cancel!(@entry)
          end.to change { @entry.status }.to('owner canceled')
        end

        it 'become uncommitable by contractor' do
          expect do
            @entry.owner.cancel!(@entry)
          end.to change { @entry.commitable?(contractor) }.from(true).to(false)
        end

        it 'become uncommitable by owner' do
          expect do
            @entry.owner.cancel!(@entry)
          end.to change { @entry.commitable?(owner) }.from(true).to(false)
        end

        it 'become uncancelable by contractor' do
          expect do
            @entry.owner.cancel!(@entry)
          end.to change { @entry.cancelable?(contractor) }.from(true).to(false)
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
          expect(@entry.payable?(contractor)).to be false
        end
      end

      context 'contractor cancel on entry' do
        before { @entry = contractor.entry!(@entry) }
        it 'change status to contractor canceled' do
          expect do
            @entry.contractor.cancel!(@entry)
          end.to change { @entry.status }.to('contractor canceled')
        end

        it 'become uncommitable by contractor' do
          expect do
            @entry.contractor.cancel!(@entry)
          end.to change { @entry.commitable?(contractor) }.from(true).to(false)
        end

        it 'become uncommitable by owner' do
          expect do
            @entry.contractor.cancel!(@entry)
          end.to change { @entry.commitable?(owner) }.from(true).to(false)
        end

        it 'become uncancelable by contractor' do
          expect do
            @entry.contractor.cancel!(@entry)
          end.to change { @entry.cancelable?(contractor) }.from(true).to(false)
        end

        it 'become uncancelable by owner' do
          expect do
            @entry.contractor.cancel!(@entry)
          end.to change { @entry.cancelable?(owner) }.from(true).to(false)
        end

        it 'is unperformable' do
          @entry.contractor.cancel!(@entry)
          expect(@entry.performable?(owner)).to be false
        end

        it 'is unpayable' do
          @entry.contractor.cancel!(@entry)
          expect(@entry.payable?(contractor)).to be false
        end
      end

      context 'owner cancel on committed' do
        before do
          @entry = contractor.entry!(@entry)
          @entry = owner.commit!(@entry)
        end

        it 'change status to owner canceled' do
          expect do
            @entry.owner.cancel!(@entry)
          end.to change { @entry.status }.to('owner canceled')
        end

        it 'is uncommitable by contractor' do
          @entry.owner.cancel!(@entry)
          expect(@entry.commitable?(contractor)).to be false
        end

        it 'is uncommitable by owner' do
          @entry.owner.cancel!(@entry)
          expect(@entry.commitable?(owner)).to be false
        end

        it 'become uncancelable by contractor' do
          expect do
            @entry.owner.cancel!(@entry)
          end.to change { @entry.cancelable?(contractor) }.from(true).to(false)
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
          expect(@entry.payable?(contractor)).to be false
        end
      end

      context 'contractor cancel on committed' do
        before do
          @entry = contractor.entry!(@entry)
          @entry = owner.commit!(@entry)
        end

        it 'change status to contractor canceled' do
          expect do
            @entry.contractor.cancel!(@entry)
          end.to change { @entry.status }.to('contractor canceled')
        end

        it 'is uncommitable by contractor' do
          @entry.contractor.cancel!(@entry)
          expect(@entry.commitable?(contractor)).to be false
        end

        it 'is uncommitable by owner' do
          @entry.contractor.cancel!(@entry)
          expect(@entry.commitable?(owner)).to be false
        end

        it 'become uncancelable by contractor' do
          expect do
            @entry.contractor.cancel!(@entry)
          end.to change { @entry.cancelable?(contractor) }.from(true).to(false)
        end

        it 'become uncancelable by owner' do
          expect do
            @entry.contractor.cancel!(@entry)
          end.to change { @entry.cancelable?(owner) }.from(true).to(false)
        end

        it 'is unperformable' do
          @entry.contractor.cancel!(@entry)
          expect(@entry.performable?(owner)).to be false
        end

        it 'is unpayable' do
          @entry.contractor.cancel!(@entry)
          expect(@entry.payable?(contractor)).to be false
        end
      end

      context 'cancel on canlceled' do
        before do
          @entry = contractor.entry!(@entry)
          @entry = @entry.owner.cancel!(@entry)
        end

        it 'raise RuntimeError with owner canceled' do
          expect do
            owner.cancel!(@entry)
          end.to raise_error(RuntimeError)
        end

        it 'raise RuntimeError with owner canceled' do
          expect do
            contractor.cancel!(@entry)
          end.to raise_error(RuntimeError)
        end
      end
    end
  end
end
