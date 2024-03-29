class RacesController < ApplicationController
  before_action :forbid
  before_action :current
  before_action :lists

  def forbid
    if session[:op_id] == nil
      redirect_to("/operations/login")
    end
    if session[:op_id].to_i >= 5
      redirect_to("/operations/top")
    end
  end

  def current
    @current_op = Operator.find_by(id: session[:op_id])
    @year = Date.today.year
    if @current_op.id == 2
      @tour = 1
    elsif @current_op.id == 3
      @tour = 2
    elsif @current_op.id == 4
      @tour = 3
    end
  end

  def lists
    @singles = ["K-1-1000m", "C-1-1000m", "WK-1-500m", "WC-1-500m",
               "JK-1-500m", "JC-1-500m", "JWK-1-500m", "JWC-1-500m",
               "K-1-200m", "C-1-200m", "WK-1-200m", "WC-1-200m",
               "JK-1-200m", "JC-1-200m", "JWK-1-200m", "JWC-1-200m",
               "2020JK-1-500m", "2020JC-1-500m", "2020JWK-1-500m", "2020JWC-1-500m",
               "2021JK-1-500m", "2021JC-1-500m", "2021JWK-1-500m", "2021JWC-1-500m",
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

  def index
    @races = Race.where(year: @year, tour: @tour).order(:race_no)
  end

  def entries1
    @race_name = params[:race_name]
    @entries1 = Player.joins(:entries).where(year: @year).where("entries.tour" => @tour)
                                .where("entries.race_name" => @race_name).order(:u_name)
  end

  def entries2
    @race_name = params[:race_name]
    if @race_name.include?("200")
      @entries2 = Player.includes(:pair_twos).joins(:entries).where(year: @year)
                            .where("entries.tour" => @tour).where("entries.race_name" => @race_name )
                            .order(:u_name)
    else
      @entries2 = Player.includes(:pairs).joins(:entries).where(year: @year)
                            .where("entries.tour" => @tour).where("entries.race_name" => @race_name )
                            .order(:u_name)
    end
  end

  def entries4
    @race_name = params[:race_name]
    @universities = University.joins(:fours).where("fours.year" => @year)
                                            .where("fours.tour" => @tour)
                                            .where("fours.race_name" => @race_name)
  end

  def make
    races = Race.where(year: @year, tour: @tour)
    races.destroy_all
    @singles.each do |race_name|
      count = Player.joins(:entries).where(year: @year,
                      "entries.tour" => @tour, "entries.race_name" => race_name).count
      # Fの作成
      if count >= 1
        race = Race.new(
          year: @year,
          tour: @tour,
          race_name: race_name,
          stage: "F",
          set: 1
        )
        race.save
        # 全日本の場合はBFを追加
        if @tour_id == 1 && race_name.in?(["K-1-1000m", "C-1-1000m", "WK-1-500m"])
          race = Race.new(
            year: @year,
            tour: @tour,
            race_name: race_name,
            stage: "F",
            set: 2
          )
          race.save
        end
      end
      # SFの作成
      if count >= 28
        for set in 1..3 do
          race = Race.new(
            year: @year,
            tour: @tour,
            race_name: race_name,
            stage: "SF",
            set: set
          )
          race.save
        end
      elsif count >= 19 && count <= 27
        for set in 1..2 do
          race = Race.new(
            year: @year,
            tour: @tour,
            race_name: race_name,
            stage: "SF",
            set: set
          )
          race.save
        end
      end
      # Hの作成
      # 2組から7組まで
      if count >= 10 && count <= 63
        num = (count + 8) / 9
        for set in 1..num do
          race = Race.new(
            year: @year,
            tour: @tour,
            race_name: race_name,
            stage: "H",
            set: set
          )
          race.save
        end
      end
      # 8 9組
      if count >= 64 && count <= 81
        for set in 1..5 do
          race = Race.new(
            year: @year,
            tour: @tour,
            race_name: race_name,
            stage: "H",
            set: set
          )
          race.save
        end
      end
      # 10から12組
      if count >= 82 && count <= 108
        for set in 1..6 do
          race = Race.new(
            year: @year,
            tour: @tour,
            race_name: race_name,
            stage: "H",
            set: set
          )
          race.save
        end
      end
      # 1次Hの作成
      if count >= 64 && count <= 108
        num = (count + 8) / 9
        for set in 1..num do
          race = Race.new(
            year: @year,
            tour: @tour,
            race_name: race_name,
            stage: "1次H",
            set: set
          )
          race.save
        end
      end
    end
    @pairs.each do |race_name|
      count = Player.joins(:entries).where(year: @year,
                      "entries.tour" => @tour, "entries.race_name" => race_name).count/2
      # Fの作成
      if count >= 1
        race = Race.new(
          year: @year,
          tour: @tour,
          race_name: race_name,
          stage: "F",
          set: 1
        )
        race.save
      end
      # SFの作成
      if count >= 28
        for set in 1..3 do
          race = Race.new(
            year: @year,
            tour: @tour,
            race_name: race_name,
            stage: "SF",
            set: set
          )
          race.save
        end
      elsif count >= 19 && count <= 27
        for set in 1..2 do
          race = Race.new(
            year: @year,
            tour: @tour,
            race_name: race_name,
            stage: "SF",
            set: set
          )
          race.save
        end
      end
      # Hの作成
      # 2組から7組まで
      if count >= 10 && count <= 63
        num = (count + 8) / 9
        for set in 1..num do
          race = Race.new(
            year: @year,
            tour: @tour,
            race_name: race_name,
            stage: "H",
            set: set
          )
          race.save
        end
      end
      if count >= 72 && count <= 89
        for set in 1..5 do
          race = Race.new(
            year: @year,
            tour: @tour,
            race_name: race_name,
            stage: "H",
            set: set
          )
          race.save
        end
      end
      if count >= 90 && count <= 116
        for set in 1..6 do
          race = Race.new(
            year: @year,
            tour: @tour,
            race_name: race_name,
            stage: "H",
            set: set
          )
          race.save
        end
      end
    end
    @fours.each do |race_name|
      count = University.joins(:fours).where("fours.year" => @year,
                      "fours.tour" => @tour, "fours.race_name" => race_name).count
      # Fの作成
      if count >= 1
        race = Race.new(
          year: @year,
          tour: @tour,
          race_name: race_name,
          stage: "F",
          set: 1
        )
        race.save
      end
      # Hの作成
      if count >= 10 && count <= 18
        for set in 1..2 do
          race = Race.new(
            year: @year,
            tour: @tour,
            race_name: race_name,
            stage: "H",
            set: set
          )
          race.save
        end
      end
    end
    flash[:notice] = "レースを一括作成しました"
    redirect_to("/operations/races")
  end

  def show
    @race_name = params[:race_name]
    @races = Race.where(
      year: @year,
      tour: @tour,
      race_name: @race_name
    ).order(:race_no)
  end

  def change
    race_name = params[:race_name]
    stage = params[:stage]
    race_no = params[:race_no].to_i
    races = Race.where(
      year: @year,
      tour: @tour,
      race_name: race_name,
      stage: stage
    ).order(:set)
    races.each do |race|
      race.race_no = race_no
      if race.save
        race_no += 1
      else
        flash[:notice] = "レースNoが重複しました。やり直してください。"
        redirect_to controller: 'races', action: 'show' , race_name: race_name
      end
    end
    flash[:notice] = "レースNoを変更しました"
    if params[:mode] == "1"
      redirect_to controller: 'races', action: 'show' , race_name: race_name
    elsif params[:mode] == "2"
      redirect_to("/operations/races")
    end
  end

  def add
    race_name = params[:race_name]
    stage = params[:stage]
    set = params[:set]
    race_no = params[:race_no]
    race = Race.new(year: @year, tour: @tour, race_name: race_name, stage: stage, set: set.to_i)
    race.race_no = race_no.to_i if race_no != ""
    if race.save
      flash[:notice] = "レースを作成しました"
      redirect_to controller: 'races', action: 'show' , race_name: race_name
    else
      flash[:notice] = "エラー：レースを追加できませんでした。"
      redirect_to controller: 'races', action: 'show' , race_name: race_name
    end

  end

  def delete
    race = Race.find(params[:race_id])
    race.destroy
    flash[:notice] = "レースを削除しました"
    redirect_to controller: 'races', action: 'show' , race_name: race.race_name
  end

end
