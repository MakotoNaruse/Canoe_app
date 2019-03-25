class ResultsController < ApplicationController
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

  def search
  end

  def add
    race_no = params[:race_no].to_i
    @race = Race.find_by(year: @year, tour: @tour, race_no: race_no)
    if !@race
      flash[:notice] = "レースが存在しません"
      redirect_to("/operations/results/search") and return
    end
    ranks = Rank.where(race_id: @race.id).order(:rank)
    @ranks = Array.new(10)
    rnk = 1
    ranks.each do |rank|
      @ranks[rnk] = rank.rane
      rnk +=1
    end
  end


  def added
    race_id = params[:race_id].to_i
    ms = Array.new(10)
    ms[1] = params[:m1]
    ms[2] = params[:m2]
    ms[3] = params[:m3]
    ms[4] = params[:m4]
    ms[5] = params[:m5]
    ms[6] = params[:m6]
    ms[7] = params[:m7]
    ms[8] = params[:m8]
    ms[9] = params[:m9]
    ms[10] = params[:m10]
    ss = Array.new(10)
    ss[1] = params[:s1]
    ss[2] = params[:s2]
    ss[3] = params[:s3]
    ss[4] = params[:s4]
    ss[5] = params[:s5]
    ss[6] = params[:s6]
    ss[7] = params[:s7]
    ss[8] = params[:s8]
    ss[9] = params[:s9]
    ss[10] = params[:s10]
    cs = Array.new(10)
    cs[1] = params[:c1]
    cs[2] = params[:c2]
    cs[3] = params[:c3]
    cs[4] = params[:c4]
    cs[5] = params[:c5]
    cs[6] = params[:c6]
    cs[7] = params[:c7]
    cs[8] = params[:c8]
    cs[9] = params[:c9]
    cs[10] = params[:c10]
    for num in 1..10 do
      if cs[num] != "" && ss[num] != ""
        result = Result.where(race_id: race_id, rane: num)
        if result
          result.destroy_all
        end
        result = Result.new(race_id: race_id, rane: num, m: ms[num], s: ss[num], c: cs[num])
        result.save
      end
    end
    flash[:notice] = "タイムを追加しました"
    redirect_to("/operations/results/search")
  end
end
