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
end
