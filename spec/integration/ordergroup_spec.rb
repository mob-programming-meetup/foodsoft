require_relative '../spec_helper'

feature Foodcoop::OrdergroupsController do
  let(:user) { create :user, groups: [create(:ordergroup)] }
  before { login user }

  describe ':index', js: true do
  before { visit foodcoop_ordergroups_path }

    it 'can visit supplier foodcoop ordergroups path' do
      expect(page).to have_content("Name1")
    end
  end
end