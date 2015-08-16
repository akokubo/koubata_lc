require 'rails_helper'

describe Contract do
  let(:owner) { FactoryGirl.create(:user) }
  let(:user) { FactoryGirl.create(:user) }
  let(:offering) { FactoryGirl.create(:offering, user: owner) }

  # @contractの作成
  before do
    FactoryGirl.create(:account, user: user)
    FactoryGirl.create(:account, user: owner)

    @contract = offering.contracts.build(
      user: user,
      note: 'Lorem ipsum' * 10,
      expected_at: Time.now.ago(1),
      price: 5
    )
  end

  # contractを対象としたテストを実施
  subject { @contract }

  # 属性に反応するか
  it { should respond_to(:offering) }

  # メソッドに反応するか
  it { should respond_to(:performer?) }
  it { expect(@contract.performer?(@contract.owner)).to be true }
  it { expect(@contract.performer?(@contract.user)).to be false }
  it { should respond_to(:payer?) }
  it { expect(@contract.payer?(@contract.owner)).to be false }
  it { expect(@contract.payer?(@contract.user)).to be true }
  it { should respond_to(:payee) }
  it { expect(@contract.payee).to eq @contract.owner }

  # 適正なデータが検証に通るか
  it { should be_valid }

  describe "with user's method" do
    context 'perform' do
      it 'change status to be paid by owner perform' do
        @contract = user.entry!(offering, expected_at: Time.now, price: 10)
        @contract = owner.commit!(@contract)
        expect do
          @contract = owner.perform!(@contract)
        end.to change { @contract.status }.to('to be paid')
      end
    end

    context 'pay_for' do
      it 'change status to closed by user paid' do
        @contract = user.entry!(offering, expected_at: Time.now, price: 10)
        @contract = owner.commit!(@contract)
        @contract = owner.perform!(@contract)
        expect do
          @contract = user.pay_for!(@contract)
        end.to change { @contract.status }.to('closed')
      end
    end

    context 'cancel' do
      context 'on performed' do
        before do
          @contract = user.entry!(offering, expected_at: Time.now, price: 10)
          @contract = owner.commit!(@contract)
          @contract = owner.perform!(@contract)
        end

        it 'raise RuntimeError with owner canceled' do
          expect do
            @contract.owner.cancel!(@contract)
          end.to raise_error(RuntimeError)
        end

        it 'raise RuntimeError with user canceled' do
          expect do
            @contract.user.cancel!(@contract)
          end.to raise_error(RuntimeError)
        end
      end
      context 'on closed' do
        before do
          @contract = user.entry!(offering, expected_at: Time.now, price: 10)
          @contract = owner.commit!(@contract)
          @contract = owner.perform!(@contract)
          @contract = user.pay_for!(@contract)
        end

        it 'raise RuntimeError with owner canceled' do
          expect do
            @contract.owner.cancel!(@contract)
          end.to raise_error(RuntimeError)
        end

        it 'raise RuntimeError with user canceled' do
          expect do
            @contract.user.cancel!(@contract)
          end.to raise_error(RuntimeError)
        end
      end
    end
  end
end
