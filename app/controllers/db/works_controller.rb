class Db::WorksController < Db::ApplicationController
  permits :season_id, :sc_tid, :title, :media, :official_site_url, :wikipedia_url,
          :twitter_username, :twitter_hashtag, :released_at, :released_at_about,
          :fetch_syobocal

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index(page: nil)
    @works = Work.order("released_at DESC NULLS LAST").page(page)
  end

  def season(page: nil, slug: ENV["ANNICT_CURRENT_SEASON"])
    @works = Work.by_season(slug).order("released_at DESC NULLS LAST").page(page)
    render :index
  end

  def resourceless(page: nil, name: "episode")
    @works = case name
             when "episode" then Work.where(episodes_count: 0)
             when "item" then Work.where(items_count: 0)
             end
    @works = @works.order(watchers_count: :desc).page(page)
    render :index
  end

  def search(page: nil, q: "")
    @works = Work.where("lower(title) LIKE ?", "%#{q}%")
      .order("released_at DESC NULLS LAST")
      .page(page)
    render :index
  end

  def new
    @work = Work.new
    authorize @work, :new?
  end

  def create(work)
    @work = Work.new(format_params(work))
    authorize @work, :create?

    if @work.save
      redirect_to db_works_path, notice: "作品を登録しました"
    else
      render :new
    end
  end

  def edit(id)
    @work = Work.find(id)
    authorize @work, :edit?
  end

  def update(id, work)
    @work = Work.find(id)
    authorize @work, :update?

    if @work.update_attributes(format_params(work))
      redirect_to db_works_path, notice: "作品を更新しました"
    else
      render :edit
    end
  end

  def destroy(id)
    @work = Work.find(id)
    authorize @work, :destroy?

    @work.destroy

    redirect_to db_works_path, notice: "作品を削除しました"
  end

  private

  def format_params(work_params)
    released_at = work_params[:released_at].strip.gsub(/年|月/, '-').delete('日')
    work_params[:released_at] = released_at
    work_params
  end
end