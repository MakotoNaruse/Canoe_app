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
      # 開発用
      # @universies = University.order(:erea).order(:read)
      # 本番用
      @universies = University.order(:erea).order('read COLLATE "C" ASC')
      @tour = 1
    elsif @current_op.id == 3
      # 開発用
      # @universies = University.where(erea: "関西").order(:read)
      # 本番用
      @universies = University.where(erea: "関西").order('read COLLATE "C" ASC')
      @tour = 2
    elsif @current_op.id == 4
      # 開発用
      # @universies = University.where(erea: "関東").order(:read)
      # 本番用
      @universies = University.where(erea: "関東").order('read COLLATE "C" ASC')
      @tour = 3
    end
  end

  def assign
    if @current_op.id == 2
      # 開発用
      # @universies = University.order(:erea).order(:read)
      # 本番用
      @universies = University.order(:erea).order('read COLLATE "C" ASC')
      @tour = 1
    elsif @current_op.id == 3
      # 開発用
      # @universies = University.where(erea: "関西").order(:read)
      # 本番用
      @universies = University.where(erea: "関西").order('read COLLATE "C" ASC')
      @tour = 2
    elsif @current_op.id == 4
      # 開発用
      # @universies = University.where(erea: "関東").order(:read)
      # 本番用
      @universies = University.where(erea: "関東").order('read COLLATE "C" ASC')
      @tour = 3
    end

    #支部大会の場合、ゼッケンは数字のみ
    if @tour == 2 || @tour == 3
      i = 1
      @universies.each do |university|
        # 開発用
        # players = Player.where(u_name: university.u_name).order({grade: :desc}, :typ).order(:reading)
        # 本番用
        players = Player.where(u_name: university.u_name).order({grade: :desc}, :typ).order('reading COLLATE "C" ASC')
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
    end

    # インカレの場合、関西にはw、関東にはeを付与する
    if @tour == 1
      i = 1
      @universies.where(erea: "関東").each do |university|
        # 開発用
        # players = Player.where(u_name: university.u_name).order({grade: :desc}, :typ).order(:reading)
        # 本番用
        players = Player.where(u_name: university.u_name).order({grade: :desc}, :typ).order('reading COLLATE "C" ASC')
        players.each do |player|
          @bib = Bib.find_by(player_id: player.id, tour: @tour )
          if @bib
            @bib.bib_no = i.to_s + 'e'
            @bib.save
          else
            @bib = Bib.new(
                    player_id: player.id,
                    tour: @tour,
                    bib_no: i.to_s + 'e'
                   )
            @bib.save
          end
          i += 1
        end
      end
      i = 1
      @universies.where(erea: "関西").each do |university|
        # 開発用
        # players = Player.where(u_name: university.u_name).order({grade: :desc}, :typ).order(:reading)
        # 本番用
        players = Player.where(u_name: university.u_name).order({grade: :desc}, :typ).order('reading COLLATE "C" ASC')
        players.each do |player|
          @bib = Bib.find_by(player_id: player.id, tour: @tour )
          if @bib
            @bib.bib_no = i.to_s + 'w'
            @bib.save
          else
            @bib = Bib.new(
                    player_id: player.id,
                    tour: @tour,
                    bib_no: i.to_s + 'w'
                   )
            @bib.save
          end
          i += 1
        end
      end
    end

    flash[:notice] = "ゼッケンを割り振りました"
    redirect_to("/operations/bibs")
  end
end
