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
    @fours = Four.where(university_id: @current_univ.id, tour: @current_tour_id, year: @year)
  end

  def add
    @search = Four.find_by(
      race_name: params[:race_name],
      university_id: @current_univ.id,
      tour: @current_tour_id,
      year: @year
    )
    if @search
      flash[:notice] = "すでに登録されています"
    else
      @four = Four.new(
        race_name: params[:race_name],
        university_id: @current_univ.id,
        tour: @current_tour_id,
        year: @year
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
