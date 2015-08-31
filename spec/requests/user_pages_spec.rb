require 'rails_helper'

describe 'My Status' do
  subject { page }

  describe 'user signed in' do
    before do
      user = FactoryGirl.create(:user)
      FactoryGirl.create(:account, user: user)
      visit new_user_session_path
      fill_in User.human_attribute_name(:email), with: user.email
      fill_in User.human_attribute_name(:password), with: user.password
      click_button I18n.t('Sign in')
    end

    context 'My Status' do
      it { should have_title(I18n.t('My Status')) }
      it { should have_content(I18n.t('Current balance')) }
      it { should have_content(User.human_attribute_name(:description)) }
      it { should have_link(User.human_attribute_name(:followed_users)) }
      it { should have_link(User.human_attribute_name(:followers)) }
      it { should have_link(Notification.model_name.human) }
      it { should have_link(Talk.model_name.human) }
      it { should have_link(Account.model_name.human) }
      it { should have_link(Offering.model_name.human) }
      it { should have_link(Want.model_name.human) }
      it { should have_link(I18n.t('Contract')) }
      it { should have_link(I18n.t('Entrust')) }
      it { should have_link(I18n.t('Settings')) }
      it { should have_link(I18n.t('Home')) }
    end
  end

  describe 'user not signed in' do
    before do
      user = FactoryGirl.create(:user)
      FactoryGirl.create(:account, user: user)
      get status_path
    end

    context 'My Status' do
      it { expect(response).to redirect_to(new_user_session_path) }
    end
  end
end
