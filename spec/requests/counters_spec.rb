require 'rails_helper'

RSpec.describe "Counters", type: :request do
  let(:user) { create(:user) }
  let(:sushi_item) { create(:sushi_item) }

  before do
    sign_in user
    counter = create(:counter, user: user, store_name: "くら寿司", saved: true)
  end

  describe "GET /counters/new" do
    it "正しいビューに遷移する" do
      get new_counter_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /counters/:id" do
    it "index画面に遷移し、保存され、コインが増える" do
      get new_counter_path
      counter = user.counters.order(created_at: :desc).first
  
      sushi_item # ← 作成しておく
  
      # カウント情報を追加（nested attributes）
      counter.sushi_item_counters.create!(sushi_item: sushi_item, count: 5)
  
      expect {
        patch counter_path(counter), params: {
          counter: {
            store_name: "スシロー",
            update_source: "new"
          }
        }
      }.to change { user.reload.coin }.by(counter.total_sushi_count)
    end
  end


  describe "GET /counters" do
    it "保存したcounterが表示される" do
      get counters_path
      expect(response.body).to include("くら寿司")
    end
  end

  describe "GET /counters/:id/edit" do
    it "正しいビューに遷移する" do
      counter = create(:counter, user: user)
      get edit_counter_path(counter)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /counters/:id" do
    it "カウント情報を更新できる" do
      counter = create(:counter, user: user, store_name: "元の店名")
      patch counter_path(counter), params: { counter: { store_name: "新しい店名" } }
      expect(response).to redirect_to(counters_path)
      expect(counter.reload.store_name).to eq("新しい店名")
    end
  end

  describe "DELETE /counters/:id" do
    it "Counterを削除できる" do
      counter = create(:counter, user: user)
      expect {
        delete counter_path(counter)
      }.to change(Counter, :count).by(-1)

      expect(response).to redirect_to(counters_path)
    end
  end

  describe "GET /counters/summary" do
    it "正しいビューに遷移する" do
      get summary_counters_path
      expect(response).to have_http_status(:ok)
    end
  end
end
