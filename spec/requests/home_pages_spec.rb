require 'rails_helper'

describe 'Home Pages' do
  it 'should have the right links on the home page' do
    visit root_path
    click_link 'ユーザー登録する'
    expect(page).to have_title('ユーザー登録する')

    visit root_path
    click_link 'ログイン'
    expect(page).to have_title('ログイン')
  end

  subject { page }

  describe 'Home page' do
    before { visit root_path }
    it { should have_title(full_title('')) }
    it { should have_title('ハッピー幸畑たすけあい') }
    it { should_not have_title('ホーム - ') }
  end

  describe 'Need Help page' do
    before { visit need_help_path }
    it { should have_title('お困りですか？') }
  end

  describe 'About page' do
    before { visit about_path }
    it { should have_title('「ハッピー幸畑たすけあい」とは') }
  end

  describe 'Contact page' do
    before { visit contact_path }
    it { should have_title('お問い合わせ') }
  end
end
