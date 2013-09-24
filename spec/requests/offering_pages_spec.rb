require 'spec_helper'

describe "Offering pages" do
  subject { page }

  describe "new page" do
    before { visit new_offering_path }

    it { should have_content('New') }
    it { should have_content('New offering') }
  end
end