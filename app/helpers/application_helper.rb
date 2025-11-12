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
      path = path = image.service_url
      cdn_host = "https://sushi-counter.imgix.net"
      uri = URI(path)
      uri.host = URI(cdn_host).host
      image_tag uri.to_s, **options
    else
      image_tag image, **options
    end
  end
end
