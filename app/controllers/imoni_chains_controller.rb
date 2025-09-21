class ImoniChainsController < ApplicationController
  before_action :set_imoni_chain, only: [:show]

  def index
    @imoni_chains = ImoniChain.recent
    @current_chain = @imoni_chains.first
    @total_chains = ImoniChain.count
  end

  def show
  end

  def gacha
    # ガチャページ（芋煮チェーンを作成する画面）
    @previous_chain = ImoniChain.recent.first
    @available_ingredients = ImoniChain::BASIC_INGREDIENTS + ImoniChain::SPECIAL_INGREDIENTS
  end

  def spin
    # ガチャ実行（新しいチェーンを作成）
    creator_name = params[:creator_name].presence || "匿名の芋煮マスター"
    custom_ingredient = params[:custom_ingredient].presence

    @new_chain = ImoniChain.create_new_chain(creator_name, custom_ingredient)

    if @new_chain.persisted?
      redirect_to @new_chain, notice: "芋煮チェーン #{@new_chain.chain_number} 連鎖目が完成しました！"
    else
      redirect_to gacha_imoni_chains_path, alert: "芋煮の作成に失敗しました。もう一度お試しください。"
    end
  end

  def new
    # フォームでの手動作成（使わないかも）
    @imoni_chain = ImoniChain.new
    @previous_chain = ImoniChain.recent.first
  end

  def create
    # フォームからの作成（使わないかも）
    @imoni_chain = ImoniChain.new(imoni_chain_params)

    if @imoni_chain.save
      redirect_to @imoni_chain, notice: 'Imoni chain was successfully created.'
    else
      render :new
    end
  end

  private

  def set_imoni_chain
    @imoni_chain = ImoniChain.find(params[:id])
  end

  def imoni_chain_params
    params.require(:imoni_chain).permit(:creator_name, :new_ingredient)
  end
end
