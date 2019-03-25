class CombinationsController < ApplicationController
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
    if @current_op.id == 2 || @current_op.id == 5
      @tour = 1
    elsif @current_op.id == 3 || @current_op.id == 6
      @tour = 2
    elsif @current_op.id == 4 || @current_op.id == 7
      @tour = 3
    end
  end

  def lists
    @singles = ["K-1-1000m", "C-1-1000m", "WK-1-500m", "WC-1-500m",
               "JK-1-500m", "JC-1-500m", "JWK-1-500m", "JWC-1-500m",
               "K-1-200m", "C-1-200m", "WK-1-200m", "WC-1-200m",
               "JK-1-200m", "JC-1-200m", "JWK-1-200m", "JWC-1-200m"]
    @pairs = ["K-2-1000m", "C-2-1000m", "WK-2-500m", "WC-2-500m",
               "JK-2-500m", "JC-2-500m", "JWK-2-500m", "JWC-2-500m",
               "K-2-200m", "C-2-200m", "WK-2-200m", "WC-2-200m"]
    @fours = ["K-4-1000m", "C-4-1000m", "WK-4-500m",
             "K-1-Relay", "C-1-Relay", "WK-1-Relay"]
  end

  def index
    @races = Race.includes(:combinations).where(year: @year, tour: @tour).order(:race_no)
  end

  def lott
    @singles.each do |race_name|
      players = Array.new(20).map{Array.new(1,0)}
      entries = Player.joins(:entries).where(year: @year).where("entries.tour" => @tour)
                      .where("entries.race_name" => race_name).order(:u_name)

      # 選手idを配列に格納
      univ_id = 0
      player_id = 0
      count = 0
      univ = Array.new(1)
      entries.each do |player|
        univ[count] = player.u_name
        if count != 0
          if univ[count] != univ[count-1]
            player_id = 0
            univ_id += 1
          end
        end
        players[univ_id][player_id] = player.id
        count += 1
        player_id += 1
      end

      # 大学内でシャッフル
      players.each do |players_univ|
        players_univ.shuffle!
      end

      #各組に振り分ける
      number = entries.count #艇数
      total_set = (number + 8) / 9
      combi = Array.new(total_set).map{Array.new(9, 0)} #振り分ける配列
      set = 0
      rane = 0
      players.each do |players_univ|
        players_univ.each do |player|
          if player != 0
            combi[set][rane] = player
            if set == total_set - 1
              set = 0
              rane += 1
            else
              set += 1
            end
          end
        end
      end


      #組内でシャッフル
      combi.each do |combi_set|
        combi_set.delete(0)
        if combi_set.length != 1
          # 隣り合いがなくなるまでやり直す
          for try in 1..100 do
            combi_set.shuffle!
            # チェック作業
            check = 0
            for num in 1...combi_set.length do
              # 隣合っていたらcheckを1に
              if Player.find_by(id: combi_set[num]).u_name == Player.find_by(id: combi_set[num-1]).u_name
                check = 1
              end
            end
            # 隣合っていなかったらループを抜ける
            if check == 0
              break
            end
          end
        end
      end

      #抽選結果をDBに格納する
      set = 1
      combi.each do |combi_set|
        # 1組の場合はFとなる　真ん中に寄せる
        if total_set == 1
          race = Race.find_by(year: @year, tour: @tour, race_name: race_name, stage: "F" )
          cmbs = Combination.where(race_id: race.id )
          if cmbs
            cmbs.destroy_all
          end
          if combi_set.length >= 8
            dev = 0
          elsif combi_set.length >= 6 && combi_set.length <= 7
            dev = 1
          elsif combi_set.length >= 4 && combi_set.length <= 5
            dev = 2
          elsif combi_set.length >= 2 && combi_set.length <= 3
            dev = 3
          elsif combi_set.length == 1
            dev = 4
          end
          for rane in 1..combi_set.length do
            cmb = Combination.new(race_id: race.id, rane: rane+dev, player_id: combi_set[rane-1] )
            cmb.save
          end
        # 7組までの場合はHとなる　1レーンに寄せる
        elsif total_set >= 2 && total_set <= 7
          race = Race.find_by(year: @year, tour: @tour, race_name: race_name, stage: "H", set: set )
          cmbs = Combination.where(race_id: race.id )
          if cmbs
            cmbs.destroy_all
          end
          for rane in 1..combi_set.length do
            cmb = Combination.new(race_id: race.id, rane: rane, player_id: combi_set[rane-1] )
            cmb.save
          end
          set += 1
        # 8組以上は1次Hとなる　同上
        elsif total_set >= 8
          race = Race.find_by(year: @year, tour: @tour, race_name: race_name, stage: "1次H", set: set )
          cmbs = Combination.where(race_id: race.id )
          if cmbs
            cmbs.destroy_all
          end
          for rane in 1..combi_set.length do
            cmb = Combination.new(race_id: race.id, rane: rane, player_id: combi_set[rane-1] )
            cmb.save
          end
          set += 1
        end
      end
    end
    flash[:notice] = "抽選を実施しました"
    redirect_to("/operations/combinations")
  end

  def add
  end

  def comfirm
    race_no = params[:race_no].to_i
    @race = Race.find_by(year: @year, tour: @tour, race_no: race_no)
    if !@race
      flash[:notice] = "レースが存在しませんでした"
      redirect_to("/operations/combinations/add")
    end

    @bibs = Array.new(11)
    @bibs[0] = params[:rane0].to_i
    @bibs[1] = params[:rane1].to_i
    @bibs[2] = params[:rane2].to_i
    @bibs[3] = params[:rane3].to_i
    @bibs[4] = params[:rane4].to_i
    @bibs[5] = params[:rane5].to_i
    @bibs[6] = params[:rane6].to_i
    @bibs[7] = params[:rane7].to_i
    @bibs[8] = params[:rane8].to_i
    @bibs[9] = params[:rane9].to_i
    @bibs[10] = params[:rane10].to_i

    @names = Array.new(11)
    @univs = Array.new(11)
    for num in 0..10 do
      if @bibs[num] != 0
        bib = Bib.find_by(tour: @tour, bib_no: @bibs[num])
        if bib
          player_id = bib.player_id
          player = Player.find_by(id: player_id)
          @names[num] = player.p_name
          @univs[num] = player.u_name
        end
      end
    end

  end

  def added
    race_no = params[:race_no].to_i
    race = Race.find_by(year: @year, tour: @tour, race_no: race_no)
    if !race
      flash[:notice] = "レースが存在せず追加できませんでした"
      redirect_to("/operations/combinations/add")
    end
    bibs = Array.new(11)
    bibs[0] = params[:rane0].to_i
    bibs[1] = params[:rane1].to_i
    bibs[2] = params[:rane2].to_i
    bibs[3] = params[:rane3].to_i
    bibs[4] = params[:rane4].to_i
    bibs[5] = params[:rane5].to_i
    bibs[6] = params[:rane6].to_i
    bibs[7] = params[:rane7].to_i
    bibs[8] = params[:rane8].to_i
    bibs[9] = params[:rane9].to_i
    bibs[10] = params[:rane10].to_i
    for num in 0..10 do
      if bibs[num] != 0
        bib = Bib.find_by(tour: @tour, bib_no: bibs[num])
        if bib
          player_id = bib.player_id
          combi = Combination.new(race_id: race.id, rane: num, player_id: player_id)
          combi.save
        end
      end
    end
    flash[:notice] = "組み合わせを追加しました"
    redirect_to("/operations/combinations/add")
  end

end
