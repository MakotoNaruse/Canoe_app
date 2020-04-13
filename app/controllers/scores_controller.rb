class ScoresController < ApplicationController
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

  def index
    scores = Score.where(year: @year, tour: @tour)
    scores.destroy_all

    races = Race.where(year: @year, tour: @tour, stage: "F", set:1)

    races.each do |race|
      ranks = Rank.where(race_id: race.id).order(:rank)
      ranks.each do |rank|
        if race.race_name.include?("-4-") || race.race_name.include?("Relay")
          combi = CombinationFour.find_by(race_id: race.id, rane: rank.rane)
          score = Score.find_by(u_name: combi.u_name)
        else
          combi = Combination.find_by(race_id: race.id, rane: rank.rane)
          player = Player.find(combi.player_id)
          score = Score.find_by(u_name: player.u_name)
        end

        # ジュニアの場合
        if race.race_name.include?("J")
          if rank.rank.to_i >= 1 && rank.rank.to_i <= 6
            plus_score = 7 - rank.rank.to_i
            if race.race_name.include?("JK")
              score.jmk_score = score.jmk_score.to_i + plus_score
              score.jm_score = score.jm_score.to_i + plus_score
            elsif race.race_name.include?("JC")
              score.jmc_score = score.jmc_score.to_i + plus_score
              score.jm_score = score.jm_score.to_i + plus_score
            elsif race.race_name.include?("JWK")
              score.jwk_score = score.jwk_score.to_i + plus_score
              score.jw_score = score.jw_score.to_i + plus_score
            elsif race.race_name.include?("JWC")
              score.jwc_score = score.jwc_score.to_i + plus_score
              score.jw_score = score.jw_score.to_i + plus_score
            end
          end


        # シニア　フォア・リレーの場合
        elsif race.race_name.include?("-4-") || race.race_name.include?("Relay")
          if rank.rank.to_i == 1
            plus_score = 18
          elsif rank.rank.to_i == 2
            plus_score = 14
          elsif rank.rank.to_i == 3
            plus_score = 10
          elsif rank.rank.to_i == 4
            plus_score = 8
          elsif rank.rank.to_i == 5
            plus_score = 6
          elsif rank.rank.to_i == 6
            plus_score = 4
          elsif rank.rank.to_i == 7
            plus_score = 3
          elsif rank.rank.to_i == 8
            plus_score = 2
          elsif rank.rank.to_i == 9
            plus_score = 1
          end
          if race.race_name.include?("K")
            score.mk_score = score.mk_score.to_i + plus_score
            score.m_score = score.m_score.to_i + plus_score
          elsif race.race_name.include?("C")
            score.mc_score = score.mc_score.to_i + plus_score
            score.m_score = score.m_score.to_i + plus_score
          elsif race.race_name.include?("WK")
            score.wk_score = score.wk_score.to_i + plus_score
            score.w_score = score.w_score.to_i + plus_score
          end

        # その他
        else
          if rank.rank.to_i == 1
            plus_score = 10
          elsif rank.rank.to_i == 2
            plus_score = 8
          elsif rank.rank.to_i == 3
            plus_score = 7
          elsif rank.rank.to_i == 4
            plus_score = 6
          elsif rank.rank.to_i == 5
            plus_score =5
          elsif rank.rank.to_i == 6
            plus_score = 4
          elsif rank.rank.to_i == 7
            plus_score = 3
          elsif rank.rank.to_i == 8
            plus_score = 2
          elsif rank.rank.to_i == 9
            plus_score = 1
          end
          if race.race_name.include?("K")
            score.mk_score = score.mk_score.to_i + plus_score
            score.m_score = score.m_score.to_i + plus_score
          elsif race.race_name.include?("C")
            score.mc_score = score.mc_score.to_i + plus_score
            score.m_score = score.m_score.to_i + plus_score
          elsif race.race_name.include?("WK")
            score.wk_score = score.wk_score.to_i + plus_score
            score.w_score = score.w_score.to_i + plus_score
          elsif race.race_name.include?("WC")
            score.wc_score = score.wc_score.to_i + plus_score
            score.w_score = score.w_score.to_i + plus_score
          end
        end

        score.save

      end
    end
    @scores = Score.all
  end
end
