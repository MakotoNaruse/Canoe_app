class RanksController < ApplicationController
  before_action :forbid
  before_action :current

  def forbid
    if session[:op_id] == nil
      redirect_to("/operations/login")
    end
  end

  def current
    @current_op = Operator.find_by(id: session[:op_id])
    @year = Date.today.year
    if @current_op.id == 2 || @current_op.id == 5
      @tour = 1
    elsif @current_op.id == 3 || @current_op.id == 6
      @tour = 2
    elsif @current_op.id == 4 || @current_op.id == 7
      @tour = 3
    end
  end

  def add
  end


  def added
    race_no = params[:race_no].to_i
    race = Race.find_by(year: @year, tour: @tour, race_no: race_no)
    if !race
      flash[:notice] = "レースが存在せず追加できませんでした"
      redirect_to("/operations/ranks/add") and return
    end
    ranks = Array.new(11)
    ranks[1] = params[:rank1].to_i
    ranks[2] = params[:rank2].to_i
    ranks[3] = params[:rank3].to_i
    ranks[4] = params[:rank4].to_i
    ranks[5] = params[:rank5].to_i
    ranks[6] = params[:rank6].to_i
    ranks[7] = params[:rank7].to_i
    ranks[8] = params[:rank8].to_i
    ranks[9] = params[:rank9].to_i
    ranks[10] = params[:rank10].to_i
    check = 0
    for num in 1..10 do
      if ranks[num] >= 11 or ranks[num] < 0
        flash[:notice] = "順位が不正です"
        redirect_to("/operations/ranks/add") and return
      end
    end
    for num in 1..10 do
      if ranks[num] != 0
        rank = Rank.find_by(race_id: race.id, rank: num)
        if rank
          rank.destroy
        end
        rank = Rank.new(race_id: race.id, rane: ranks[num], rank: num)
        rank.save
      end
    end
    flash[:notice] = "順位を追加しました"
    redirect_to("/operations/ranks/add")
  end
end
