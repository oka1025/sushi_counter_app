
require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }

  describe "GET /users/sign_in" do
    it "ログインページが表示される" do
      get new_user_session_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("ログイン") # ビューに合わせて文言調整
    end
  end

  describe "POST /users/sign_in" do
    context "正しいメールアドレスとパスワードの場合" do
      it "ログインに成功しリダイレクトされる" do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
        expect(response).to redirect_to(root_path) # デフォルトリダイレクト先に合わせて調整
        follow_redirect!
      end
    end

    context "誤ったパスワードの場合" do
      it "ログインに失敗し再表示される" do
        post user_session_path, params: { user: { email: user.email, password: "wrong_password" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /users/sign_out" do
    before do
      sign_in user
    end

    it "ログアウトに成功しリダイレクトされる" do
      delete destroy_user_session_path
      expect(response).to redirect_to(root_path) # ログアウト後の遷移先に合わせて
      follow_redirect!
    end
  end
end
