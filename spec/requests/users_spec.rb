
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

  describe "POST /users (sign up)" do
    context "正しい情報が送信された場合" do
      it "ユーザー登録に成功しリダイレクトされる" do
        expect {
          post user_registration_path, params: {
            user: {
              email: "newuser@example.com",
              password: "password123",
              password_confirmation: "password123",
              name: "新規ユーザー"
            }
          }
        }.to change(User, :count).by(1)

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("メニュー") # ログイン状態のUIなどに合わせて調整
      end
    end

    context "不正な情報が送信された場合（パスワード不一致など）" do
      it "ユーザー登録に失敗しエラーメッセージが表示される" do
        expect {
          post user_registration_path, params: {
            user: {
              email: "invalid@example.com",
              password: "password123",
              password_confirmation: "mismatch",
              name: "エラー"
            }
          }
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("パスワード(確認)とパスワードの入力が一致しません") # 日本語訳に応じて調整
      end
    end
  end
end
