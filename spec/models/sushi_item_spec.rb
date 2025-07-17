require 'rails_helper'

RSpec.describe SushiItem, type: :model do
  describe "バリデーションチェック" do
    it "正しい値でバリデーションが通ること" do
      sushi = build(:sushi_item)
      expect(sushi).to be_valid
    end

    it "nameがない場合にバリデーションが機能してinvalidになるか" do
      sushi_without_name = build(:sushi_item, name:"")
      expect(sushi_without_name).to be_invalid
    end

    it "カテゴリを選択していない場合にバリデーションが機能してinvalidになるか" do
      sushi_without_category = build(:sushi_item, category: nil)
      expect(sushi_without_category).to be_invalid
    end
  end
end