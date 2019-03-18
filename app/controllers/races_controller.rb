class RacesController < ApplicationController
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
    if @current_op.id == 2
      @tour = 1
    elsif @current_op.id == 3
      @tour = 2
    elsif @current_op.id == 4
      @tour = 3
    end
  end

  def index
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

  def entries1
    @race_name = params[:race_name]
    @entries1 = Player.joins(:entries).where(year: @year).where("entries.tour" => @tour)
                                .where("entries.race_name" => @race_name).order(:u_name)
  end

  def entries2
    @race_name = params[:race_name]
    @entries2 = Player.includes(:pairs).joins(:entries).where(year: @year)
                          .where("entries.tour" => @tour).where("entries.race_name" => @race_name )
                          .order(:u_name)
  end

  def entries4
    @race_name = params[:race_name]
    @universities = University.joins(:fours).where("fours.year" => @year)
                                            .where("fours.tour" => @tour)
                                            .where("fours.race_name" => @race_name)
  end

end
