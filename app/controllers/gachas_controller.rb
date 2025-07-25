class GachasController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user, only: [:draw, :result]

  def show
    @user = current_user
    @gacha_lists = GachaList.all
  end

  def draw
    draw_count = params[:times].to_i == 10 ? 10 : 1
    required_coin = 5 * draw_count

    if current_user.coin < required_coin
      redirect_to gachas_path, alert: t('gachas.coin_alert')
      return
    end

    gacha_pool = GachaList.all.to_a
    weighted_pool = gacha_pool.flat_map { |g| [g] * g.weight }
    sr_or_higher = gacha_pool.select { |g| %w[super_rare special].include?(g.rarity) }
    weighted_sr_pool = sr_or_higher.flat_map { |g| [g] * g.weight }

    results = []
    if draw_count == 10
      9.times { results << weighted_pool.sample }
      results << weighted_sr_pool.sample
    else
      results << weighted_pool.sample
    end

    results.each do |selected|
      current_user.user_gacha_lists.create!(gacha_list: selected)
    end
    current_user.update(coin: current_user.coin - required_coin)

    session[:latest_gacha_items] = results.map(&:id)
    redirect_to result_gachas_path
  end

  def result
    ids = session[:latest_gacha_items] || []
    id_counts = ids.tally
    all_items = GachaList.where(id: ids).index_by(&:id)
    @results = ids.map { |id| all_items[id] }

    if @results.last&.image&.attached?
      image = url_for(@results.last.image)
    else
      image = view_context.image_url("ogp_default.png")
    end
  end

  def destroy_session
    session.delete(:gacha_result_ids)
    redirect_to gachas_path
  end

  private

  def reject_guest_user
    if current_user&.guest?
      redirect_to gachas_path, alert: t('counters.guest_alert')
    end
  end
end
