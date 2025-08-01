require 'rails_helper'

RSpec.describe "Bookmarks", type: :request do
  let(:user) { create(:user) }
  let(:sushi_item) { create(:sushi_item) }

  before do
    sign_in user
  end

  describe "POST /sushi_items/:sushi_item_id/bookmark" do
    it "お気に入りを登録できる" do
      expect {
        post sushi_item_bookmark_path(sushi_item)
      }.to change(Bookmark, :count).by(1)

      expect(response).to have_http_status(:success).or have_http_status(:found) # HTMLかTurbo
      expect(user.bookmarked_sushi_items).to include(sushi_item)
    end
  end

  describe "DELETE /sushi_items/:sushi_item_id/bookmark" do
    before do
      create(:bookmark, user: user, sushi_item: sushi_item)
    end

    it "お気に入りを解除できる" do
      expect {
        delete sushi_item_bookmark_path(sushi_item)
      }.to change(Bookmark, :count).by(-1)

      expect(response).to have_http_status(:success).or have_http_status(:found)
      expect(user.bookmarked_sushi_items).not_to include(sushi_item)
    end
  end
end
