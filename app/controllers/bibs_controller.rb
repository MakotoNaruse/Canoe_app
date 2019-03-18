class BibsController < ApplicationController
  before_action :forbid
  before_action :current

  def forbid
    if session[:op_id] == nil
      redirect_to("/operations/login")
    elsif session[:op_id] >= 5 || session[:op_id] <= 1
      redirect_to("/operations/top")
    end
  end

  def current
    @current_op = Operator.find_by(id: session[:op_id])
    @year = Date.today.year
  end

  def index
    if @current_op.id == 2
      @universies = University.order(:erea, :read)
      @tour = 1
    elsif @current_op.id == 3
      @universies = University.where(erea: "関西").order("read")
      @tour = 2
    elsif @current_op.id == 4
      @universies = University.where(erea: "関東").order("read")
      @tour = 3
    end
  end

  def assign
    if @current_op.id == 2
      @universies = University.order(:erea, :read)
      @tour = 1
    elsif @current_op.id == 3
      @universies = University.where(erea: "関西").order("read")
      @tour = 2
    elsif @current_op.id == 4
      @universies = University.where(erea: "関東").order("read")
      @tour = 3
    end



    i = 1
    @universies.each do |university|
      players = Player.where(u_name: university.u_name).order({grade: :desc}, :typ)
      players.each do |player|
        @bib = Bib.find_by(player_id: player.id, tour: @tour )
        if @bib
          @bib.bib_no = i.to_s
          @bib.save
        else
          @bib = Bib.new(
                  player_id: player.id,
                  tour: @tour,
                  bib_no: i.to_s
                 )
          @bib.save
        end
        i += 1
      end
    end
    flash[:notice] = "ゼッケンを割り振りました"
    redirect_to("/operations/bibs")
  end
end
