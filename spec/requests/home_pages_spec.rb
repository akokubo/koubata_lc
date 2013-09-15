require 'spec_helper'

describe "Home Pages" do
  describe "home page" do
    it "should be contaion '幸畑プロジェクト'" do
      visit root_path
      expect(page).to have_content('幸畑プロジェクト')
    end
  end
end
