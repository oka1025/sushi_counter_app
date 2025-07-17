require 'rails_helper'

RSpec.describe "SushiItems", type: :request do
  let(:user) { create(:user) }
  let!(:category) { create(:category) } 
  let!(:other_category) { create(:category) }

  before { sign_in user }

  describe "GET /sushi_items/:id/edit" do
    context "自分が作成した寿司の場合" do
      let!(:sushi_item) { create(:sushi_item, created_by_user_id: user.id, category: category) }

      it "編集ページを表示できる" do
        get edit_sushi_item_path(sushi_item), params: { category_id: category.id }
        expect(response).to have_http_status(:ok)
      end

      it "名前を編集できる" do
        patch sushi_item_path(sushi_item), params: {
          sushi_item: { name: "新しい名前" },
          category_id: category.id
        }
        expect(response).to redirect_to(sushi_items_path(category_id: category.id))
        follow_redirect!
        expect(response.body).to include("新しい名前")
        expect(sushi_item.reload.name).to eq("新しい名前")
      end

      it "カテゴリを編集できる" do
        patch sushi_item_path(sushi_item), params: {
          sushi_item: { category_id: other_category.id },
          category_id: category.id
        }
        expect(response).to redirect_to(sushi_items_path(category_id: category.id))
        follow_redirect!
        expect(sushi_item.reload.category_id).to eq(other_category.id)
      end

      it "画像を追加できる" do
        file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'sample.png'), 'image/png')
        patch sushi_item_path(sushi_item), params: {
          sushi_item: { image: file },
          category_id: category.id
        }
        expect(response).to redirect_to(sushi_items_path(category_id: category.id))
        follow_redirect!
        expect(sushi_item.reload.image).to be_attached
      end

      it "画像を削除できる" do
        # 事前に画像を添付しておく
        sushi_item.image.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'sample.png')),
          filename: 'sample.png',
          content_type: 'image/png'
        )

        patch sushi_item_path(sushi_item), params: {
          sushi_item: { remove_image: '1' },
          category_id: category.id
        }
        expect(response).to redirect_to(sushi_items_path(category_id: category.id))
        follow_redirect!
        expect(sushi_item.reload.image).not_to be_attached
      end
    end

    context "他人が作成した寿司の場合" do
      let!(:other_user) { create(:user) }
      let!(:other_sushi) { create(:sushi_item, created_by_user_id: other_user.id, category: category) }

      it "リダイレクトされてアラートが出る" do
        get edit_sushi_item_path(other_sushi), params: { category_id: category.id }
        expect(response).to redirect_to(sushi_items_path)
      end
    end

    context "作成者が未設定（nil）の寿司の場合" do
      let!(:sushi_without_creator) { create(:sushi_item, created_by_user_id: nil, category: category) }

      it "編集ページを表示できる" do
        get edit_sushi_item_path(sushi_without_creator), params: { category_id: category.id }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
