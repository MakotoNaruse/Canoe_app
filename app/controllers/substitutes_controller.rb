class SubstitutesController < ApplicationController

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
                        .order({grade: :desc}, :typ)
    @substitutes = Substitute.where(u_name: @current_univ.u_name).where(year: @year)
                              .where(tour: @current_tour_id)
  end

  def add
    @search = Substitute.find_by(
      u_name: @current_univ.u_name,
      race_name: params[:race_name],
      main_id: params[:regular][:player_id],
      sub_id: params[:substitute][:player_id],
      year: @year,
      tour: @current_tour_id
    )
    @regular = Player.find_by(id: params[:regular][:player_id])
    @sub = Player.find_by(id: params[:substitute][:player_id])
    if @search
      flash[:notice] = "すでに登録済の補欠です"
    elsif @regular == nil || @sub == nil
      flash[:notice] = "権限がありません"
    elsif @regular.u_name != @current_univ.u_name || @sub.u_name != @current_univ.u_name
      flash[:notice] = "権限がありません"
    else
      @substitute = Substitute.new(
        u_name: @current_univ.u_name,
        race_name: params[:race_name],
        main_id: params[:regular][:player_id],
        sub_id: params[:substitute][:player_id],
        year: @year,
        tour: @current_tour_id
        )
      if @substitute.save
        flash[:notice] = "補欠を登録しました"
      else
        flash[:notice] = "補欠を登録できませんでした"
      end
    end
    redirect_to("/substitutes/index")
  end

  def destroy
    @sub = Substitute.find_by(id: params[:id])
    @sub.destroy
    flash[:notice] = "エントリーを削除しました"
    redirect_to("/substitutes/index")
  end

end
