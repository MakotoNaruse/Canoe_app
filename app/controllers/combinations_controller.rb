class CombinationsController < ApplicationController
  before_action :forbid, only: [:index, :lott, :add, :added, :comfirm]
  before_action :current
  before_action :lists
  before_action :forbid_time, only: [:results, :results_name, :search]

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
               "JK-1-200m", "JC-1-200m", "JWK-1-200m", "JWC-1-200m"]
    @pairs = ["K-2-1000m", "C-2-1000m", "WK-2-500m", "WC-2-500m",
               "JK-2-500m", "JC-2-500m", "JWK-2-500m", "JWC-2-500m",
               "K-2-200m", "C-2-200m", "WK-2-200m", "WC-2-200m"]
    @fours = ["K-4-1000m", "C-4-1000m", "WK-4-500m",
             "K-1-Relay", "C-1-Relay", "WK-1-Relay"]
  end

  def forbid_time
    op = Operation.all
    start = DateTime.new(@year, op.find(27).command.to_i, op.find(28).command.to_i, op.find(29).command.to_i, op.find(30).command.to_i, 0, 0.375)
    finish = DateTime.new(@year, op.find(31).command.to_i, op.find(32).command.to_i, op.find(33).command.to_i, op.find(34).command.to_i, 0, 0.375)
    now = DateTime.now
    if now > start && now < finish && session[:op_id] == nil
      redirect_to("/forbid_by_time")
    end
  end

  def forbid_by_time
    op = Operation.all
    @finish = DateTime.new(@year, op.find(31).command.to_i, op.find(32).command.to_i, op.find(33).command.to_i, op.find(34).command.to_i, 0, 0.375)
  end

  def index
    @races = Race.where(year: @year, tour: @tour).order(:race_no)
  end


  def lott
    #フラグ
    warning = 0

    @race_name = params[:race_name]
    if @race_name != ""
      if @singles.include?(@race_name)
        @singles = [@race_name]
        @pairs = []
        @fours = []
      end
      if @pairs.include?(@race_name)
        @singles = []
        @pairs = [@race_name]
        @fours = []
      end
    end

    #シングルの抽選
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
            # 隣り合ってしまった場合はフラグを立てておく
            if try == 100
              warning = 1
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

    #ペアの抽選
    @pairs.each do |race_name|
      players = Array.new(20).map{Array.new(1,0)}
      if race_name.include?("200")
        entries = Player.includes(:pair_twos).joins(:entries).where(year: @year)
                            .where("entries.tour" => @tour).where("entries.race_name" => race_name )
                            .order(:u_name)

                            # 選手idを配列に格納
                            univ_id = 0
                            player_id = 0
                            count = 0
                            univ = Array.new(1)
                            entries.each do |player|
                              player.pair_twos.each do |pair|
                                if pair.tour == @tour
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
                              end
                            end




      else
        entries = Player.includes(:pairs).joins(:entries).where(year: @year)
                          .where("entries.tour" => @tour).where("entries.race_name" => race_name )
                            .order(:u_name)

                            # 選手idを配列に格納
                            univ_id = 0
                            player_id = 0
                            count = 0
                            univ = Array.new(1)
                            entries.each do |player|
                              player.pairs.each do |pair|
                                if pair.tour == @tour
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
                              end
                            end
      end


      # 大学内でシャッフル
      players.each do |players_univ|
        players_univ.shuffle!
      end

      #各組に振り分ける
      number = entries.count/2 #艇数
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
            # 隣り合ってしまった場合はフラグを立てておく
            if try == 100
              warning = 1
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

    # フォア・リレーの抽選
    @fours.each do |race_name|
      univs = Array.new(1)
      entries = Four.where(year: @year, tour: @tour, race_name: race_name)

      #エントリーがない場合はスキップ
      if entries.first == nil
        next
      end

      #大学idを配列に格納
      count = 0
      entries.each do |entry|
        univs[count] = entry.university_id
        count += 1
      end

      #シャッフル
      univs.shuffle!

      #各組に振り分ける
      number = entries.count #艇数
      total_set = (number + 8) / 9
      combi = Array.new(total_set).map{Array.new(9, 0)}
      set = 0
      rane = 0
      univs.each do |univ|
        if univ != 0
          combi[set][rane] = univ
          if set == total_set - 1
            set = 0
            rane += 1
          else
            set += 1
          end
        end
      end

      #埋まってないレーンは消去
      combi.each do |combi_set|
        combi_set.delete(0)
      end

      #抽選結果をDBに格納する
      set = 1
      combi.each do |combi_set|
        # 1組の場合はFとなる　真ん中に寄せる
        if total_set == 1
          race = Race.find_by(year: @year, tour: @tour, race_name: race_name, stage: "F" )
          cmbs = CombinationFour.where(race_id: race.id )
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
            univ = University.find_by(id: combi_set[rane-1])
            cmb = CombinationFour.new(race_id: race.id, rane: rane+dev, u_name: univ.u_name )
            cmb.save
          end
        # 7組までの場合はHとなる　1レーンに寄せる
        elsif total_set >= 2 && total_set <= 7
          race = Race.find_by(year: @year, tour: @tour, race_name: race_name, stage: "H", set: set )
          cmbs = CombinationFour.where(race_id: race.id )
          if cmbs
            cmbs.destroy_all
          end
          for rane in 1..combi_set.length do
            univ = University.find_by(id: combi_set[rane-1])
            cmb = CombinationFour.new(race_id: race.id, rane: rane, u_name: univ.u_name )
            cmb.save
          end
          set += 1
        end
      end

    end

    if warning == 1
      flash[:notice] = "抽選を実施しましたが大学が隣り合っっている箇所があります"
    else
      flash[:notice] = "抽選を実施しました"
    end
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
    @bibs[0] = params[:rane0]
    @bibs[1] = params[:rane1]
    @bibs[2] = params[:rane2]
    @bibs[3] = params[:rane3]
    @bibs[4] = params[:rane4]
    @bibs[5] = params[:rane5]
    @bibs[6] = params[:rane6]
    @bibs[7] = params[:rane7]
    @bibs[8] = params[:rane8]
    @bibs[9] = params[:rane9]
    @bibs[10] = params[:rane10]

    @names = Array.new(11)
    @univs = Array.new(11)
    for num in 0..10 do
      if @bibs[num] != 0
        player = Player.joins(:bibs).find_by(year: @year, "bibs.tour" => @tour, "bibs.bib_no" => @bibs[num] )
        if player
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
      redirect_to("/operations/combinations/add") and return
    end
    bibs = Array.new(11)
    bibs[0] = params[:rane0]
    bibs[1] = params[:rane1]
    bibs[2] = params[:rane2]
    bibs[3] = params[:rane3]
    bibs[4] = params[:rane4]
    bibs[5] = params[:rane5]
    bibs[6] = params[:rane6]
    bibs[7] = params[:rane7]
    bibs[8] = params[:rane8]
    bibs[9] = params[:rane9]
    bibs[10] = params[:rane10]

    if combi = Combination.where(race_id: race.id)
      combi.destroy_all
    end

    for num in 0..10 do
      if bibs[num] != ""
        player = Player.joins(:bibs).find_by(year: @year, "bibs.tour" => @tour, "bibs.bib_no" => bibs[num] )
        if player
          player_id = player.id
          combi = Combination.new(race_id: race.id, rane: num, player_id: player_id)
          combi.save
        end
      end
    end
    flash[:notice] = "組み合わせを追加しました"
    redirect_to("/operations/combinations/add")
  end

  def results
    @yr = params[:year]
    @tr = params[:tour]
    @race_no = params[:race_no]
    @race_name = params[:race_name]
    @stage = params[:stage]
    @set = params[:set]
    @races = Race.includes({combinations: {player: :bibs}}, :ranks, :results).order(:race_no)
    if @yr != "" then @races = @races.where(year: @yr.to_i) end
    if @tr != "" then @races = @races.where(tour: @tr.to_i) end
    if @race_no != "" then @races = @races.where(race_no: @race_no.to_i) end
    if @race_name != "" then @races = @races.where(race_name: @race_name) end
    if @stage != "" then @races = @races.where(stage: @stage) end
    if @set != "" then @races = @races.where(set: @set.to_i) end
  end

  def results_name
    @yr = params[:year]
    @tr = params[:tour]
    @u_name = params[:u_name]
    @p_name = params[:p_name]
    @players = Player.where(year: @yr).where("u_name LIKE ? AND p_name LIKE ?",
                        "%#{@u_name}%", "%#{@p_name}%").order({grade: :desc}, :typ)
  end

  def search
  end

  def results_json
    @yr = params[:year]
    @tr = params[:tour]
    @race_no = params[:race_no]
    @race_name = params[:race_name]
    @stage = params[:stage]
    @set = params[:set]
    @races = Race.includes({combinations: {player: :bibs}}, :ranks, :results).order(:race_no)
    if @yr != "" then @races = @races.where(year: @yr.to_i) end
    if @tr != "" then @races = @races.where(tour: @tr.to_i) end
    if @race_no != "" then @races = @races.where(race_no: @race_no.to_i) end
    if @race_name != "" then @races = @races.where(race_name: @race_name) end
    if @stage != "" then @races = @races.where(stage: @stage) end
    if @set != "" then @races = @races.where(set: @set.to_i) end

    result = {}
    races_json = []
    if @races.first
      @races.each do |race|
        race_json = {}
        if race.stage == 'F'
          race_json['race_no'] = race.race_no
          race_json['race_name'] = race.race_name 
          set = Race.where(year: @yr, tour: @tr, race_name: race.race_name, stage: "F").count
          if set <= 1
            race_json['stage'] = "F"
            race_json['set'] = 1
          else
            if race.set == 1
              race_json['stage'] = "BF"
              race_json['set'] = 1
            else 
              race_json['stage'] = "AF" 
              race_json['set'] = 1
            end
          end
        else
          race_json['race_no'] = race.race_no
          race_json['race_name'] = race.race_name 
          race_json['stage'] = race.stage
          race_json['set'] = race.set
        end
        if race.race_name.include?("-1-") && !race.race_name.include?("Relay")
          ranks = race.ranks.to_a.group_by{ |rank| rank.rane }
          results = race.results.to_a.group_by{ |result| result.rane }
          combis_json = []
          race.combinations.each do |combi|
            if combi
              combi_json = {}
              combi_json['rane'] = combi.rane
              bibs = combi.player.bibs.to_a.group_by{ |bib| bib.tour }
              if bibs[race.tour]
                combi_json['bib_no'] = bibs[race.tour][0].bib_no 
              else 
                combi_json['rane'] = "" 
              end 
              combi_json['p_name'] = combi.player.p_name 
              combi_json['u_name'] = combi.player.u_name  
              if ranks[combi.rane]
                combi_json['rank'] = ranks[combi.rane][0].rank 
              else 
                combi_json['rank'] = ""
              end
              if results[combi.rane]
                if results[combi.rane][0].m
                  combi_json['min'] = results[combi.rane][0].m 
                else 
                  combi_json['min'] = "" 
                end 
                if results[combi.rane][0].s 
                  combi_json['sec'] = results[combi.rane][0].s 
                else 
                  combi_json['sec'] = "" 
                end 
                if results[combi.rane][0].c 
                  combi_json['milisec'] = results[combi.rane][0].c 
                else 
                  combi_json['milisec']  = "" end 
                if results[combi.rane][0].option
                  combi_json['option'] = results[combi.rane][0].option 
                else 
                  combi_json['option']  = "" 
                end 
              else
                combi_json['min'] = "" 
                combi_json['sec'] = "" 
                combi_json['milosec'] = "" 
                combi_json['option'] = "" 
              end
              combis_json.push(combi_json)
            end
          end
        elsif race.race_name.include?("-2-")
        
        elsif race.race_name.include?("-4-") || race.race_name.include?("Relay")
        
        end
        race_json['result'] = combis_json
        races_json.push(race_json)
      end
      result['data'] = races_json
    else
      result['data'] = "レースが見つかりませんでした。"
    end

    render :json => result
  end


end
