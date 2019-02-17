class FoursController < ApplicationController
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
    @fours = Four.where(university_id: @current_univ.id, tour: @current_tour_id)
  end

  def add
    @search = Four.find_by(
      race_name: params[:race_name],
      university_id: @current_univ.id,
      tour: @current_tour_id
    )
    if @search
      flash[:notice] = "すでに登録されています"
    else
      @four = Four.new(
        race_name: params[:race_name],
        university_id: @current_univ.id,
        tour: @current_tour_id
      )
      if @four.save
        flash[:notice] = "エントリーを追加しました。"
      else
        flash[:notice] = "エントリーを追加できませんでした。"
      end
    end
    redirect_to("/fours/index")
  end

  def destroy
    @four = Four.find_by(id: params[:id])
    if @four.university_id != @current_univ.id
      flash[:notice] = "権限がありません"
    else
      @four.destroy
      flash[:notice] = "エントリーを削除しました"
    end
    redirect_to("/fours/index")
  end

end
