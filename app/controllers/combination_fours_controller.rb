class CombinationFoursController < ApplicationController
  before_action :forbid
  before_action :current
  before_action :lists

  def forbid
    if session[:op_id] == nil
      redirect_to("/operations/login")
    end
  end

  def current
    @current_op = Operator.find_by(id: session[:op_id])
    @year = Date.today.year
    if @current_op
      if @current_op.id == 2 || @current_op.id == 5
        @tour = 1
      elsif @current_op.id == 3 || @current_op.id == 6
        @tour = 2
      elsif @current_op.id == 4 || @current_op.id == 7
        @tour = 3
      end
    end
  end

  def lists
    @singles = ["K-1-1000m", "C-1-1000m", "WK-1-500m", "WC-1-500m",
               "JK-1-500m", "JC-1-500m", "JWK-1-500m", "JWC-1-500m",
               "K-1-200m", "C-1-200m", "WK-1-200m", "WC-1-200m",
               "JK-1-200m", "JC-1-200m", "JWK-1-200m", "JWC-1-200m",
               "2020JK-1-200m", "2020JC-1-200m", "2020JWK-1-200m", "2020JWC-1-200m",
               "2021JK-1-200m", "2021JC-1-200m", "2021JWK-1-200m", "2021JWC-1-200m"]
    @pairs = ["K-2-1000m", "C-2-1000m", "WK-2-500m", "WC-2-500m",
               "JK-2-500m", "JC-2-500m", "JWK-2-500m", "JWC-2-500m",
               "K-2-200m", "C-2-200m", "WK-2-200m", "WC-2-200m",
               "2020JK-2-500m", "2020JC-2-500m", "2020JWK-2-500m", "2020JWC-2-500m",
               "2021JK-2-500m", "2021JC-2-500m", "2021JWK-2-500m", "2021JWC-2-500m"]
    @fours = ["K-4-1000m", "C-4-1000m", "WK-4-500m",
             "K-1-Relay", "C-1-Relay", "WK-1-Relay"]
  end


  def search
  end

  def add
    race_no = params[:race_no].to_i
    @race = Race.find_by(year: @year, tour: @tour, race_no: race_no)
    if !@race
      flash[:notice] = "レースが存在しません"
      redirect_to("/operations/fours/search") and return
    end
    if !@race.race_name.include?("-4-") && !@race.race_name.include?("Relay")
      flash[:notice] = "フォア・リレーのレースではありません"
      redirect_to("/operations/fours/search") and return
    end
    @fours = CombinationFour.where(race_id: @race.id).order(:rane)
  end

  def added
    race_id = params[:race_id].to_i
    race = Race.find(race_id)
    # アホな実装
    fours = Array.new(11).map{Array.new(5,"")}
    fours[0][1] = params[:pid10]
    fours[0][2] = params[:pid20]
    fours[0][3] = params[:pid30]
    fours[0][4] = params[:pid40]
    fours[1][1] = params[:pid11]
    fours[1][2] = params[:pid21]
    fours[1][3] = params[:pid31]
    fours[1][4] = params[:pid41]
    fours[2][1] = params[:pid12]
    fours[2][2] = params[:pid22]
    fours[2][3] = params[:pid32]
    fours[2][4] = params[:pid42]
    fours[3][1] = params[:pid13]
    fours[3][2] = params[:pid23]
    fours[3][3] = params[:pid33]
    fours[3][4] = params[:pid43]
    fours[4][1] = params[:pid14]
    fours[4][2] = params[:pid24]
    fours[4][3] = params[:pid34]
    fours[4][4] = params[:pid44]
    fours[5][1] = params[:pid15]
    fours[5][2] = params[:pid25]
    fours[5][3] = params[:pid35]
    fours[5][4] = params[:pid45]
    fours[6][1] = params[:pid16]
    fours[6][2] = params[:pid26]
    fours[6][3] = params[:pid36]
    fours[6][4] = params[:pid46]
    fours[7][1] = params[:pid17]
    fours[7][2] = params[:pid27]
    fours[7][3] = params[:pid37]
    fours[7][4] = params[:pid47]
    fours[8][1] = params[:pid18]
    fours[8][2] = params[:pid28]
    fours[8][3] = params[:pid38]
    fours[8][4] = params[:pid48]
    fours[9][1] = params[:pid19]
    fours[9][2] = params[:pid29]
    fours[9][3] = params[:pid39]
    fours[9][4] = params[:pid49]
    fours[10][1] = params[:pid110]
    fours[10][2] = params[:pid210]
    fours[10][3] = params[:pid310]
    fours[10][4] = params[:pid410]

    pid = Array.new(5)

    for rane in 0..10 do
      four = CombinationFour.find_by(race_id: race.id, rane: rane)
      if four
        for num in 1..4 do
          if player = Player.joins(:bibs).find_by(year: @year, "bibs.tour" => @tour, "bibs.bib_no" => fours[rane][num] )
            pid[num] = player.id
          else
            pid[num] = 0
          end
        end
        four.player_id1 = pid[1] if pid[1] != 0
        four.player_id2 = pid[2] if pid[2] != 0
        four.player_id3 = pid[3] if pid[3] != 0
        four.player_id4 = pid[4] if pid[4] != 0
        four.save
      end
    end

    flash[:notice] = "フォア・リレーの選手を登録しました。"
    redirect_to("/operations/fours/search")
  end

  def combi_search
  end

  def combi_add
    race_no = params[:race_no].to_i
    @race = Race.find_by(year: @year, tour: @tour, race_no: race_no)
    if !@race
      flash[:notice] = "レースが存在しません"
      redirect_to("/operations/fours/combi_search") and return
    end
    if !@race.race_name.include?("-4-") && !@race.race_name.include?("Relay")
      flash[:notice] = "フォア・リレーのレースではありません"
      redirect_to("/operations/fours/combi_search") and return
    end
    @universities = University.all if @tour == 1
    @universities = University.where(erea: "関西") if @tour == 2
    @universities = University.where(erea: "関東") if @tour == 3
  end

  def combi_added
    race_id = params[:race_id].to_i
    race = Race.find(race_id)

    univs = Array.new(11)
    univs[0] = params[:rane0]
    univs[1] = params[:rane1]
    univs[2] = params[:rane2]
    univs[3] = params[:rane3]
    univs[4] = params[:rane4]
    univs[5] = params[:rane5]
    univs[6] = params[:rane6]
    univs[7] = params[:rane7]
    univs[8] = params[:rane8]
    univs[9] = params[:rane9]
    univs[10] = params[:rane10]

    if  combi = CombinationFour.where(race_id: race.id)
      combi.destroy_all
    end

    for num in 0..10 do
      if univs[num] != ""
        combi = CombinationFour.new(race_id: race.id, rane: num, u_name: univs[num])
        combi.save
      end
    end
    flash[:notice] = "フォア・リレー組み合わせを追加しました"
    redirect_to("/operations/fours/combi_search")
  end

end
