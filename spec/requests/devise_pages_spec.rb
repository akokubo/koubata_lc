require 'spec_helper'

describe "Devise Pages" do

  subject { page }

  describe "sign up page" do
    before { visit new_user_registration_path }

    it { should have_content(I18n.t('Sign up')) }
    it { should have_title(full_title(I18n.t('Sign up'))) }
  end

  describe "sign up" do
    before { visit new_user_registration_path }

    let(:submit) { I18n.t('Sign up') }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in I18n.t("activerecord.attributes.user.name"),
          with: "Example User"
        fill_in I18n.t("activerecord.attributes.user.email"),
          with: "user@example.com"
        fill_in I18n.t("activerecord.attributes.user.password"),
          with: "foobarfoobar"
        fill_in I18n.t("activerecord.attributes.user.password_confirmation"),
          with: "foobarfoobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end
