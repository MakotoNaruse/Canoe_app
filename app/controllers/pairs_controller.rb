class PairsController < ApplicationController
  before_action :forbid
  before_action :current
  before_action :forbid_choice
  before_action :current_tour

  def forbid
    if session[:univ_id] == nil
      redirect_to("/login")
    end
  end

  def current
    @current_univ = University.find_by(id: session[:univ_id])
    @year = Date.today.year
  end

  def forbid_choice
    if session[:tour_id] == nil
      redirect_to("/reg/choice")
    elsif @current_univ.erea == "関東" && session[:tour_id].to_i == 2
      redirect_to("/reg/choice")
    elsif @current_univ.erea == "関西" && session[:tour_id].to_i == 3
      redirect_to("/reg/choice")
    else
      op = Operation.all
      if session[:tour_id].to_i == 1
        start = DateTime.new(@year, op.find(2).command.to_i, op.find(3).command.to_i, op.find(4).command.to_i, op.find(5).command.to_i, 0, 0.375)
        finish = DateTime.new(@year, op.find(14).command.to_i, op.find(15).command.to_i, op.find(16).command.to_i, op.find(17).command.to_i, 0, 0.375)
      elsif session[:tour_id].to_i == 2
        start = DateTime.new(@year, op.find(6).command.to_i, op.find(7).command.to_i, op.find(8).command.to_i, op.find(9).command.to_i, 0, 0.375)
        finish = DateTime.new(@year, op.find(18).command.to_i, op.find(19).command.to_i, op.find(20).command.to_i, op.find(21).command.to_i, 0, 0.375)
      elsif session[:tour_id].to_i == 3
        start = DateTime.new(@year, op.find(10).command.to_i, op.find(11).command.to_i, op.find(12).command.to_i, op.find(13).command.to_i, 0, 0.375)
        finish = DateTime.new(@year, op.find(22).command.to_i, op.find(23).command.to_i, op.find(24).command.to_i, op.find(25).command.to_i, 0, 0.375)
      end
      now = DateTime.now
      if ( now < start || now > finish ) && session[:op_id] == nil
        flash[:notice] = "この大会はエントリー期間外です"
        redirect_to("/reg/choice")
      end
    end
  end

  def current_tour
    @current_tour_id = session[:tour_id].to_i
    if @current_tour_id == 1
      @current_tour = "全日本インカレ"
    elsif @current_tour_id == 2
      @current_tour = "関西インカレ"
    elsif @current_tour_id == 3
      @current_tour = "関東インカレ"
    end
  end

  def index
    @players = Player.where(u_name: @current_univ.u_name).where(year: @year)
                          .order(:typ, {grade: :desc})
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
      @pair_search1 = Pair.find_by(player_id: params[:id])
      @pair_search2 = Pair.find_by(pair_id: params[:id])
      @pair_search3 = Pair.find_by(player_id: params[:pair][:id])
      @pair_search4 = Pair.find_by(pair_id: params[:pair][:id])
      if @pair_search1 || @pair_search2 || @pair_search3 || @pair_search4
        flash[:notice] = "すでにペア登録がされています"
      else
        @pair = Pair.new(
          player_id: params[:id],
          pair_id: params[:pair][:id],
          tour: @current_tour_id
        )
        if @pair.save
          flash[:notice] = "ペアを登録しました"
        else
          flash[:notice] = "ペアを登録できませんでした"
        end
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
      @pair_search1 = PairTwo.find_by(player_id: params[:id])
      @pair_search2 = PairTwo.find_by(pair_id: params[:id])
      @pair_search3 = PairTwo.find_by(player_id: params[:pair][:id])
      @pair_search4 = PairTwo.find_by(pair_id: params[:pair][:id])
      if @pair_search1 || @pair_search2 || @pair_search3 || @pair_search4
        flash[:notice] = "すでにペア登録がされています"
      else
        @pair_two = PairTwo.new(
          player_id: params[:id],
          pair_id: params[:pair][:id],
          tour: @current_tour_id
        )
        if @pair_two.save
          flash[:notice] = "ペアを登録しました"
        else
          flash[:notice] = "ペアを登録できませんでした"
        end
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
      @pair = Pair.find_by(player_id: params[:id], tour: @current_tour_id)
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
      @pair_two = PairTwo.find_by(player_id: params[:id], tour: @current_tour_id)
      @pair_two.destroy
      flash[:notice] = "ペアを削除しました"
      redirect_to("/pairs/index")
    end
  end

end
