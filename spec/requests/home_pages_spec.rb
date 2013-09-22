require 'spec_helper'

describe "Home Pages" do

  it "should have the right links on the home page" do
    visit root_path
    click_link "お困りですか？"
    expect(page).to have_title('お困りですか？')

    visit root_path
    click_link "幸畑プロジェクトとは"
    expect(page).to have_title('幸畑プロジェクトとは')

    visit root_path
    click_link "お問い合わせ"
    expect(page).to have_title('お問い合わせ')
  end

  subject { page }

  describe "Home page" do
    before { visit root_path }
    it { should have_title(full_title('')) }
    it { should have_title('幸畑プロジェクト') }
    it { should_not have_title(' - ホーム') }
  end

  describe "Need Help page" do
    before { visit need_help_path }
    it { should have_title('お困りですか？') }
  end

  describe "About page" do
    before { visit about_path }
    it { should have_title('幸畑プロジェクトとは') }
  end

  describe "Contact page" do
    before { visit contact_path }
    it { should have_title('お問い合わせ') }
  end

end
