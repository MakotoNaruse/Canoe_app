class EntriesController < ApplicationController
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
  end

  def add
    @search = Entry.find_by(
      race_name: params[:race_name],
      player_id: params[:entry][:player_id],
      tour: @current_tour_id
    )
    @player = Player.find_by(id: params[:entry][:player_id])
    if @search
      flash[:notice] = "すでに登録済のエントリーです"
    elsif @player == nil
      flash[:notice] = "権限がありません"
    elsif @player.u_name != @current_univ.u_name
      flash[:notice] = "権限がありません"
    else
      @entry = Entry.new(
        race_name: params[:race_name],
        player_id: params[:entry][:player_id],
        tour: @current_tour_id
        )
      if @entry.save
        flash[:notice] = "エントリーを登録しました"
      else
        flash[:notice] = "エントリーを登録できませんでした"
      end
    end
    redirect_to("/entries/index")
  end

  def destroy
    @entry = Entry.find_by(id: params[:id])
    @entry.destroy
    flash[:notice] = "エントリーを削除しました"
    redirect_to("/entries/index")
  end

end
