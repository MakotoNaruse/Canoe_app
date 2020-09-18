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
    # @race = Race.find_by(year: @year, tour: @tour, race_no: race_no)
    @race = Race.includes({combinations: {player: :bibs}}, :combination_fours, :ranks, :results).find_by(year: @year, tour: @tour, race_no: race_no)
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
    ranks = params[:rank]
    ms = params[:m]
    ss = params[:s]
    cs = params[:c]
    options = params[:option]
    race = Race.includes(:combinations, :combination_fours, :ranks, :results).find(race_id)
    if race.race_name.include?("-4-") || race.race_name.include?("Relay")
      race.combination_fours.each_with_index do |combi, i|
        rank = Rank.find_by(race_id: race_id, rane: combi.rane)
        if rank.present?
          rank.rank = ranks[i]
          rank.save!
        else
          rank = Rank.new(race_id: race.id, rane: combi.rane, rank: ranks[i])
          rank.save!
        end
        result = Result.find_by(race_id: race_id, rane: combi.rane)
        if result
          result.m = ms[i]
          result.s = ss[i]
          result.c = cs[i]
          result.option = options[i]
          result.save!
        else
          result = Result.new(
            race_id: race_id,
            rane: combi.rane,
            m: ms[i],
            s: ss[i],
            c: cs[i],
            option: options[i]
          )
          result.save!
        end
      end
    else
      race.combinations.each_with_index do |combi, i|
        rank = Rank.find_by(race_id: race_id, rane: combi.rane)
        if rank.present?
          rank.rank = ranks[i]
          rank.save!
        else
          rank = Rank.new(race_id: race.id, rane: combi.rane, rank: ranks[i])
          rank.save!
        end
        result = Result.find_by(race_id: race_id, rane: combi.rane)
        if result
          result.m = ms[i]
          result.s = ss[i]
          result.c = cs[i]
          result.option = options[i]
          result.save!
        else
          result = Result.new(
            race_id: race_id,
            rane: combi.rane,
            m: ms[i],
            s: ss[i],
            c: cs[i],
            option: options[i]
          )
          result.save!
        end
      end
    end

    flash[:notice] = "結果を追加しました"
    redirect_to("/operations/results/search")
  end

  def option

  end

  def option_add
    race_no = params[:race_no].to_i
    race = Race.find_by(year: @year, tour: @tour, race_no: race_no)
    options = Array.new(11)
    options[0] = params[:rane0]
    options[1] = params[:rane1]
    options[2] = params[:rane2]
    options[3] = params[:rane3]
    options[4] = params[:rane4]
    options[5] = params[:rane5]
    options[6] = params[:rane6]
    options[7] = params[:rane7]
    options[8] = params[:rane8]
    options[9] = params[:rane9]
    options[10] = params[:rane10]
    for num in 1..11 do
      if options[num] != ""
        result = Result.find_by(race_id: race.id, rane: num)
        if result
          result.option = options[num]
          result.save
        else
          result = Result.new(race_id: race.id, rane: num, option: options[num])
          result.save
        end
      end
    end
    flash[:notice] = "備考を追加しました"
    redirect_to("/operations/top")
  end

end
