class EntriesController < ApplicationController
  before_action :forbid
  before_action :current
  before_action :forbid_choice
  before_action :current_tour

  def forbid
    if session[:univ_id] == nil
      redirect_to("/login")
    end
  end

  def current
    @current_univ = University.find_by(id: session[:univ_id])
    @year = Date.today.year
  end

  def forbid_choice
    if session[:tour_id] == nil
      redirect_to("/reg/choice")
    elsif @current_univ.erea == "関東" && session[:tour_id].to_i == 2
      redirect_to("/reg/choice")
    elsif @current_univ.erea == "関西" && session[:tour_id].to_i == 3
      redirect_to("/reg/choice")
    else
      op = Operation.all
      if session[:tour_id].to_i == 1
        start = DateTime.new(@year, op.find(2).command.to_i, op.find(3).command.to_i, op.find(4).command.to_i, op.find(5).command.to_i, 0, 0.375)
        finish = DateTime.new(@year, op.find(14).command.to_i, op.find(15).command.to_i, op.find(16).command.to_i, op.find(17).command.to_i, 0, 0.375)
      elsif session[:tour_id].to_i == 2
        start = DateTime.new(@year, op.find(6).command.to_i, op.find(7).command.to_i, op.find(8).command.to_i, op.find(9).command.to_i, 0, 0.375)
        finish = DateTime.new(@year, op.find(18).command.to_i, op.find(19).command.to_i, op.find(20).command.to_i, op.find(21).command.to_i, 0, 0.375)
      elsif session[:tour_id].to_i == 3
        start = DateTime.new(@year, op.find(10).command.to_i, op.find(11).command.to_i, op.find(12).command.to_i, op.find(13).command.to_i, 0, 0.375)
        finish = DateTime.new(@year, op.find(22).command.to_i, op.find(23).command.to_i, op.find(24).command.to_i, op.find(25).command.to_i, 0, 0.375)
      end
      now = DateTime.now
      if ( now < start || now > finish ) && session[:op_id] == nil
        flash[:notice] = "この大会はエントリー期間外です"
        redirect_to("/reg/choice")
      end
    end
  end

  def current_tour
    @current_tour_id = session[:tour_id].to_i
    if @current_tour_id == 1
      @current_tour = "全日本インカレ"
    elsif @current_tour_id == 2
      @current_tour = "関西インカレ"
    elsif @current_tour_id == 3
      @current_tour = "関東インカレ"
    end
  end

  def index
    @players = Player.where(u_name: @current_univ.u_name).where(year: @year)
                        .order({grade: :desc}, :typ)
  end

  def add
    @search = Entry.find_by(
      race_name: params[:race_name],
      player_id: params[:entry][:player_id],
      tour: @current_tour_id
    )
    @player = Player.find_by(id: params[:entry][:player_id])
    if @search
      flash[:notice] = "すでに登録済のエントリーです"
    elsif @player == nil
      flash[:notice] = "権限がありません"
    elsif @player.u_name != @current_univ.u_name
      flash[:notice] = "権限がありません"
    else
      @entry = Entry.new(
        race_name: params[:race_name],
        player_id: params[:entry][:player_id],
        tour: @current_tour_id
        )
      if @entry.save
        flash[:notice] = "エントリーを登録しました"
      else
        flash[:notice] = "エントリーを登録できませんでした"
      end
    end
    redirect_to("/entries/index")
  end

  def destroy
    @entry = Entry.find_by(id: params[:id])
    @entry.destroy
    flash[:notice] = "エントリーを削除しました"
    redirect_to("/entries/index")
  end

  #全員が1000m/500mのシングルにエントリー
  def add1
    @players = Player.where(u_name: @current_univ.u_name).where(year: @year)
                        .order({grade: :desc}, :typ)
    @players.each do |player|
      if player.typ == "K"
        @search = Entry.find_by(
          race_name: "K-1-1000m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "K-1-1000m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "C"
        @search = Entry.find_by(
          race_name: "C-1-1000m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "C-1-1000m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "WK"
        @search = Entry.find_by(
          race_name: "WK-1-500m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "WK-1-500m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "WC"
        @search = Entry.find_by(
          race_name: "WC-1-500m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "WC-1-500m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "JK"
        @search = Entry.find_by(
          race_name: "JK-1-500m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "JK-1-500m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "JC"
        @search = Entry.find_by(
          race_name: "JC-1-500m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "JC-1-500m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "JWK"
        @search = Entry.find_by(
          race_name: "JWK-1-500m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "JWK-1-500m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "JWC"
        @search = Entry.find_by(
          race_name: "JWC-1-500m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "JWC-1-500m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      end
    end
    flash[:notice] = "全員を1000m/500mのシングルにエントリーしました。"
    redirect_to("/entries/index")
  end

  #全員が1000m/500mのペアにエントリー
  def add2
    @players = Player.where(u_name: @current_univ.u_name).where(year: @year)
                        .order({grade: :desc}, :typ)
    @players.each do |player|
      if player.typ == "K"
        @search = Entry.find_by(
          race_name: "K-2-1000m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "K-2-1000m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "C"
        @search = Entry.find_by(
          race_name: "C-2-1000m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "C-2-1000m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "WK"
        @search = Entry.find_by(
          race_name: "WK-2-500m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "WK-2-500m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "WC"
        @search = Entry.find_by(
          race_name: "WC-2-500m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "WC-2-500m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "JK"
        @search = Entry.find_by(
          race_name: "JK-2-500m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "JK-2-500m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "JC"
        @search = Entry.find_by(
          race_name: "JC-2-500m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "JC-2-500m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "JWK"
        @search = Entry.find_by(
          race_name: "JWK-2-500m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "JWK-2-500m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "JWC"
        @search = Entry.find_by(
          race_name: "JWC-2-500m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "JWC-2-500m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      end
    end
    flash[:notice] = "全員を1000m/500mのペアにエントリーしました。"
    redirect_to("/entries/index")
  end

  #全員が200mのシングルにエントリー
  def add3
    @players = Player.where(u_name: @current_univ.u_name).where(year: @year)
                        .order({grade: :desc}, :typ)
    @players.each do |player|
      if player.typ == "K"
        @search = Entry.find_by(
          race_name: "K-1-200m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "K-1-200m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "C"
        @search = Entry.find_by(
          race_name: "C-1-200m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "C-1-200m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "WK"
        @search = Entry.find_by(
          race_name: "WK-1-200m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "WK-1-200m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "WC"
        @search = Entry.find_by(
          race_name: "WC-1-200m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "WC-1-200m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "JK"
        @search = Entry.find_by(
          race_name: "JK-1-200m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "JK-1-200m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "JC"
        @search = Entry.find_by(
          race_name: "JC-1-200m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "JC-1-200m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "JWK"
        @search = Entry.find_by(
          race_name: "JWK-1-200m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "JWK-1-200m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "JWC"
        @search = Entry.find_by(
          race_name: "JWC-1-200m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "JWC-1-200m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      end
    end
    flash[:notice] = "全員を200mのシングルにエントリーしました。"
    redirect_to("/entries/index")
  end

  #全員(ジュニア除く)が200mのペアにエントリー
  def add4
    @players = Player.where(u_name: @current_univ.u_name).where(year: @year)
                        .order({grade: :desc}, :typ)
    @players.each do |player|
      if player.typ == "K"
        @search = Entry.find_by(
          race_name: "K-2-200m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "K-2-200m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "C"
        @search = Entry.find_by(
          race_name: "C-2-200m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "C-2-200m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "WK"
        @search = Entry.find_by(
          race_name: "WK-2-200m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "WK-2-200m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      elsif player.typ == "WC"
        @search = Entry.find_by(
          race_name: "WC-2-200m",
          player_id: player.id,
          tour: @current_tour_id
        )
        if @search == nil
          @entry = Entry.new(
            race_name: "WC-2-200m",
            player_id: player.id,
            tour: @current_tour_id
          )
          @entry.save
        end
      end
    end
    flash[:notice] = "全員(ジュニア除く)を200mのペアにエントリーしました。"
    redirect_to("/entries/index")
  end

  def delete
    @players = Player.where(u_name: @current_univ.u_name).where(year: @year)
    @players.each do |player|
      Entry.where(player_id: player.id, tour: @current_tour_id).delete_all
    end
    flash[:notice] = "全てのエントリーを削除しました。"
    redirect_to("/entries/index")
  end
end
