require 'rails_helper'

RSpec.describe "UserGachaLists", type: :request do
  let(:user) { create(:user) }
  let!(:gacha) { create(:gacha_list, name: "レア寿司") }

  before do
    create(:user_gacha_list, user: user, gacha_list: gacha)
    sign_in user
  end

  describe "GET /user_gacha_lists" do
    it "獲得したガチャ一覧が表示される" do
      get user_gacha_lists_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("レア寿司")
    end
  end
end
