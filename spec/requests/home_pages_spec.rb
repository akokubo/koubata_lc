require 'rails_helper'

describe 'Home Pages' do
  subject { page }

  describe 'click link' do
    before do
      visit root_path
    end

    context 'Sign up' do
      before { click_link I18n.t('Sign up') }
      it { should have_title(I18n.t('Sign up')) }
    end

    context 'Sign in' do
      before { click_link I18n.t('Sign in') }
      it { should have_title(I18n.t('Sign in')) }
    end

    context 'Forgot your password?' do
      before { click_link I18n.t('Forgot your password?') }
      it { should have_title(I18n.t('Forgot your password?')) }
    end

    context 'About' do
      before { click_link I18n.t('About') }
      it { should have_title(I18n.t('About')) }
    end

    context 'Contact' do
      before { click_link I18n.t('Contact') }
      it { should have_title(I18n.t('Contact')) }
    end
  end

  context 'visit Sign up page' do
    before { visit new_user_registration_path }
    it { should have_title(I18n.t('Sign up')) }
    it { should have_link(I18n.t('Home')) }
    it { should have_link(I18n.t('Sign in')) }
    it { should have_link(I18n.t("Didn't receive confirmation instructions?")) }
    it { should have_link(I18n.t("Didn't receive unlock instructions?")) }
  end

  context 'visit Sign in page' do
    before { visit new_user_session_path }
    it { should have_title(I18n.t('Sign in')) }
    it { should have_link(I18n.t('Home')) }
    it { should have_link(I18n.t('Sign up')) }
    it { should have_link(I18n.t('Forgot your password?')) }
    it { should have_link(I18n.t("Didn't receive confirmation instructions?")) }
    it { should have_link(I18n.t("Didn't receive unlock instructions?")) }
  end

  context 'visit Forgot your password? page' do
    before { visit new_user_password_path }
    it { should have_title(I18n.t('Forgot your password?')) }
    it { should have_link(I18n.t('Home')) }
    it { should have_link(I18n.t('Sign up')) }
    it { should have_link(I18n.t('Sign in')) }
    it { should have_link(I18n.t("Didn't receive confirmation instructions?")) }
    it { should have_link(I18n.t("Didn't receive unlock instructions?")) }
  end

  context 'visit Resend confirmation instructions page' do
    before { visit new_user_confirmation_path }
    it { should have_title(I18n.t('Resend confirmation instructions')) }
    it { should have_link(I18n.t('Home')) }
    it { should have_link(I18n.t('Sign up')) }
    it { should have_link(I18n.t('Sign in')) }
    it { should have_link(I18n.t('Forgot your password?')) }
    it { should have_link(I18n.t("Didn't receive unlock instructions?")) }
  end

  context 'visit Resend unlock instructions page' do
    before { visit new_user_unlock_path }
    it { should have_title(I18n.t('Resend unlock instructions')) }
    it { should have_link(I18n.t('Home')) }
    it { should have_link(I18n.t('Sign up')) }
    it { should have_link(I18n.t('Sign in')) }
    it { should have_link(I18n.t('Forgot your password?')) }
    it { should have_link(I18n.t("Didn't receive confirmation instructions?")) }
  end

  context 'visit Home page' do
    before { visit root_path }
    it { should have_title(full_title('')) }
    it { should have_title(full_title(I18n.t('Koubata Project'))) }
    it { should_not have_title(full_title("#{I18n.t('Home')} - ")) }
  end

  context 'visit About page' do
    before { visit about_path }
    it { should have_title(I18n.t('About')) }
    it { should have_link(I18n.t('Home')) }
    it { should have_link(I18n.t('Detailed')) }

    context 'visit Detailed page' do
      before { click_link I18n.t('Detailed') }
      it { should have_title(I18n.t('Detailed')) }
    end
  end

  context 'visit Contact page' do
    before { visit contact_path }
    it { should have_title(I18n.t('Contact')) }
    it { should have_link(I18n.t('Home')) }
  end

  context 'visit Detailed page' do
    before { visit detailed_path }
    it { should have_title(I18n.t('Detailed')) }
    it { should have_link(I18n.t('Home')) }
  end
end
