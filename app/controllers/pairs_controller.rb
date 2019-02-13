class PairsController < ApplicationController
  before_action :forbid
  before_action :current

  def forbid
    if session[:univ_id] == nil
      redirect_to("/login")
    end
  end

  def current
    @current_univ = University.find_by(id: session[:univ_id])
    @year = Date.today.year
  end

  def index
    @players = Player.where(u_name: @current_univ.u_name).where(year: @year)
  end

  def add
    # 存在しない選手・自大学以外の選手についての操作を禁止
    @player = Player.find_by(id: params[:id])
    @player2 = Player.find_by(id: params[:pair][:id])
    if @player == nil || @player2 == nil
      flash[:notice] = "権限がありません"
    elsif @player.u_name != @current_univ.u_name || @player2.u_name != @current_univ.u_name
      flash[:notice] = "権限がありません"
    else
      @pair = Pair.new(
        player_id: params[:id],
        pair_id: params[:pair][:id]
      )
      if @pair.save
        flash[:notice] = "ペアを登録しました"
      else
        flash[:notice] = "ペアを登録できませんでした"
      end
    end
    redirect_to("/pairs/index")
  end

  def addtwo
    # 存在しない選手・自大学以外の選手についての操作を禁止
    @player = Player.find_by(id: params[:id])
    @player2 = Player.find_by(id: params[:pair][:id])
    if @player == nil || @player2 == nil
      flash[:notice] = "権限がありません"
    elsif @player.u_name != @current_univ.u_name || @player2.u_name != @current_univ.u_name
      flash[:notice] = "権限がありません"
    else
      @pair_two = PairTwo.new(
        player_id: params[:id],
        pair_id: params[:pair][:id]
      )
      if @pair_two.save
        flash[:notice] = "ペアを登録しました"
      else
        flash[:notice] = "ペアを登録できませんでした"
      end
    end
    redirect_to("/pairs/index")
  end

  def destroy
    @player = Player.find_by(id: params[:id])
    if @player == nil
      flash[:notice] = "権限がありません"
    elsif @player.u_name != @current_univ.u_name
      flash[:notice] = "権限がありません"
    else
      @pair = Pair.find_by(player_id: params[:id])
      @pair.destroy
      flash[:notice] = "ペアを削除しました"
    end
    redirect_to("/pairs/index")
  end

  def destroytwo
    @player = Player.find_by(id: params[:id])
    if @player == nil
      flash[:notice] = "権限がありません"
    elsif @player.u_name != @current_univ.u_name
      flash[:notice] = "権限がありません"
    else
      @pair_two = PairTwo.find_by(player_id: params[:id])
      @pair_two.destroy
      flash[:notice] = "ペアを削除しました"
      redirect_to("/pairs/index")
    end
  end

end
