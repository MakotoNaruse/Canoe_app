class PlayersController < ApplicationController
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
    if session[:tour_id].to_i == 1
      @current_tour = "全日本インカレ"
    elsif session[:tour_id].to_i == 2
      @current_tour = "関西インカレ"
    elsif session[:tour_id].to_i == 3
      @current_tour = "関東インカレ"
    end
  end

  def index
    if Rails.env.production?
      @players = Player.where(u_name: @current_univ.u_name, year: @year).order({grade: :desc}, :typ).order('reading COLLATE "C" ASC')
    else
      @players = Player.where(u_name: @current_univ.u_name, year: @year).order({grade: :desc}, :typ).order(:reading)
    end
  end

  def add
    @player = Player.new(
      u_name: @current_univ.u_name,
      year: @year,
      p_name: params[:p_name],
      typ: params[:typ],
      grade: params[:grade].to_i,
      reading: params[:reading]
    )
    if @player.save
      flash[:notice] = "選手を追加しました。"
    else
      flash[:notice] = "選手を追加できませんでした。内容を確認してください。"
    end
    redirect_to("/players/index")
  end

  def edit
    @player = Player.find_by(id: params[:id])
    if @player == nil
      flash[:notice] = "権限がありません"
      redirect_to("/players/index")
    else
      if @player.u_name != @current_univ.u_name
        flash[:notice] = "権限がありません"
        redirect_to("/players/index")
      end
    end
  end

  def update
    @player = Player.find_by(id: params[:id])
    @player.p_name = params[:p_name]
    @player.typ = params[:typ]
    @player.grade = params[:grade].to_i
    @player.reading = params[:reading]
    if @player.save
      flash[:notice] = "選手を変更しました。"
      redirect_to("/players/index")
    else
      flash[:notice] = "選手を変更できませんでした。内容を確認してください。"
      render("players/edit")
    end
  end

  def destroy
    @player = Player.find_by(id: params[:id])
    if @player.u_name != @current_univ.u_name
      "権限がありません"
    else
      # 以下の記述はdependent: :destroy で代用可能？
      @pairs = Pair.where(player_id: params[:id])
      @pairs.each do |pair|
        pair.destroy
      end
      @pairs = Pair.where(pair_id: params[:id])
      @pairs.each do |pair|
        pair.destroy
      end
      @pair_twos = PairTwo.where(player_id: params[:id])
      @pair_twos.each do |pair_two|
        pair_two.destroy
      end
      @pair_twos = PairTwo.where(pair_id: params[:id])
      @pair_twos.each do |pair_two|
        pair_two.destroy
      end
      @entries = Entry.where(player_id: params[:id])
      @entries.each do |entry|
        entry.destroy
      end
      @bibs = Bib.where(player_id: params[:id])
      @bibs.each do |bib|
        bib.destroy
      end
      @player.destroy
      flash[:notice] = "選手を削除しました"
    end
    redirect_to("/players/index")
  end

end
