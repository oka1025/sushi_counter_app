module OgpHelper
  def default_meta_tags
    {
      site: "寿司カウンター",
      title: content_for?(:title) ? content_for(:title) : "寿司を楽しくカウントしよう！",
      description: content_for?(:description) ? content_for(:description) : "自分の食べた寿司を記録できるアプリ。ガチャやランキングも！",
      keywords: "寿司, カウント, 寿司ガチャ, 寿司ランキング",
      og: {
        title: :title,
        type: "website",
        url: request.original_url,
        image: image_url("/ogp_default.png"),
        site_name: :site,
        description: :description,
        locale: "ja_JP"
      },
      twitter: {
        card: "summary_large_image",
        image: image_url("/ogp_default.png")
      }
    }
  end
end
