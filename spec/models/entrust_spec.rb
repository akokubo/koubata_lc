require 'rails_helper'

describe Entrust do
  let(:owner) { FactoryGirl.create(:user) }
  let(:user) { FactoryGirl.create(:user) }
  let(:want) { FactoryGirl.create(:want, user: owner) }

  # @entrustの作成
  before do
    FactoryGirl.create(:account, user: user)
    FactoryGirl.create(:account, user: owner)

    @entrust = want.entrusts.build(
      user: user,
      note: 'Lorem ipsum' * 10,
      expected_at: Time.now.ago(1),
      price: 5
    )
  end

  # entrustを対象としたテストを実施
  subject { @entrust }

  # 属性に反応するか
  it { should respond_to(:want) }

  # メソッドに反応するか
  it { should respond_to(:performer?) }
  it { expect(@entrust.performer?(@entrust.owner)).to be false }
  it { expect(@entrust.performer?(@entrust.user)).to be true }
  it { should respond_to(:payer?) }
  it { expect(@entrust.payer?(@entrust.owner)).to be true }
  it { expect(@entrust.payer?(@entrust.user)).to be false }
  it { should respond_to(:payee) }
  it { expect(@entrust.payee).to eq @entrust.user }

  # 適正なデータが検証に通るか
  it { should be_valid }

  it 'url match to entrust_path' do
    @entrust.save
    expect(@entrust.url).to eq "/entrusts/#{@entrust.id}"
  end

  describe "with user's method" do
    context 'perform' do
      it 'change status to be paid by user perform' do
        @entrust = user.entry!(want, expected_at: Time.now, price: 10)
        @entrust = @entrust.owner.commit!(@entrust)
        expect do
          @entrust = @entrust.user.perform!(@entrust)
        end.to change { @entrust.status }.to('to be paid')
      end
    end

    context 'pay_for' do
      it 'change status to closed by owner paid' do
        @entrust = user.entry!(want, expected_at: Time.now, price: 10)
        @entrust = @entrust.owner.commit!(@entrust)
        @entrust = @entrust.user.perform!(@entrust)
        expect do
          @entrust = @entrust.owner.pay_for!(@entrust)
        end.to change { @entrust.status }.to('closed')
      end
    end

    context 'cancel' do
      context 'on performed' do
        before do
          @entrust = user.entry!(want, expected_at: Time.now, price: 10)
          @entrust = owner.commit!(@entrust)
          @entrust = user.perform!(@entrust)
        end

        it 'raise RuntimeError with owner canceled' do
          expect do
            @entrust.owner.cancel!(@entrust)
          end.to raise_error(RuntimeError)
        end

        it 'raise RuntimeError with user canceled' do
          expect do
            @entrust.user.cancel!(@entrust)
          end.to raise_error(RuntimeError)
        end
      end
      context 'on closed' do
        before do
          @entrust = user.entry!(want, expected_at: Time.now, price: 10)
          @entrust = owner.commit!(@entrust)
          @entrust = user.perform!(@entrust)
          @entrust = owner.pay_for!(@entrust)
        end

        it 'raise RuntimeError with owner canceled' do
          expect do
            @entrust.owner.cancel!(@entrust)
          end.to raise_error(RuntimeError)
        end

        it 'raise RuntimeError with user canceled' do
          expect do
            @entrust.user.cancel!(@entrust)
          end.to raise_error(RuntimeError)
        end
      end
    end
  end
end
