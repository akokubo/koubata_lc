require 'rails_helper'

describe 'Home Pages' do
  it 'should have the right links on the home page' do
    visit root_path
    click_link 'ユーザー登録する'
    expect(page).to have_title('ユーザー登録する')

    visit root_path
    click_link 'ログイン'
    expect(page).to have_title('ログイン')

    visit root_path
    click_link 'パスワード忘れはこちら'
    expect(page).to have_title('パスワード忘れはこちら')
  end

  subject { page }

  describe 'Home page' do
    before { visit root_path }
    it { should have_title(full_title('')) }
    it { should have_title(full_title('')) }
    it { should have_title('ハッピー幸畑たすけあい') }
    it { should_not have_title('ホーム - ') }
  end

  describe 'About page' do
    before { visit about_path }
    it { should have_title('「ハッピー幸畑たすけあい」とは') }
    it { should have_link('ホーム') }
  end

  describe 'Contact page' do
    before { visit contact_path }
    it { should have_title('お問い合わせ') }
    it { should have_link('ホーム') }
  end

  describe 'Detailed page' do
    before { visit detailed_path }
    it { should have_title('詳しいしくみ') }
    it { should have_link('ホーム') }
  end
end
