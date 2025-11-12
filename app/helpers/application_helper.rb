module ApplicationHelper
  def sidebar_link_item(name, path)
    class_name = 'channel'
    class_name << ' active' if current_page?(path)

    content_tag :li, class:class_name do
      link_to name, path, class: 'channel_name'
    end
  end

  def active_if(path)
    path == controller_path ? 'active' : ''
        #条件式　？　条件が正しいときの値　：　条件が間違っているときの値
  end

  def page_title(title = '')
    base_title = '寿司カウンター'
    title.present? ? "#{title} | #{base_title}" : base_title
  end

  def cdn_image_tag(image, **options)
    return unless image.attached?

    if Rails.env.production?
      # publicアクセス可能なS3直URLを取得
      url = url_for(image)
      
      # imgixホストに置き換え
      uri = URI.parse(url)
      uri.host = "sushi-counter.imgix.net"
      
      # imgixの自動圧縮・最適化パラメータを追加（任意）
      uri.query = "auto=format,compress" if uri.query.blank?
      
      image_tag uri.to_s, **options
    else
      # 開発環境は通常のimage_tag
      image_tag image, **options
    end
  rescue => e
    Rails.logger.error("[cdn_image_tag] #{e.message}")
    # 例外時は通常のimage_tagにフォールバック
    image_tag image, **options
  end
end
