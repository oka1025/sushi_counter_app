require 'rails_helper'

RSpec.describe "Gachas", type: :request do
  let(:user) { create(:user, coin: 10) }
  let!(:gacha_list) { create(:gacha_list) }

  before { sign_in user }

  describe "GET /gachas/:id" do
    it "正しいビューに遷移する" do
      gacha = create(:gacha_list)
      get gachas_path(gacha)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /gachas/draw" do
    context "コインが不足している場合" do
      it "プレイできない" do
        user.update(coin: 3)
        post draw_gachas_path, params: { times: 1 }
        expect(response).to redirect_to(gachas_path)
        follow_redirect!
        expect(response.body).to include("コインが足りません")
      end
    end

    context "コインが十分にある場合" do
      it "ガチャを引いてコインが減り、リダイレクトされる" do
        expect {
          post draw_gachas_path, params: { times: 1 }
        }.to change(UserGachaList, :count).by(1)

        expect(user.reload.coin).to eq(5)
        expect(response).to redirect_to(result_gachas_path)
      end
    end
  end

  describe "GET /gachas/result" do
    it "結果画面が表示される" do
      get result_gachas_path
      expect(response).to have_http_status(:ok)
    end
  end
end
