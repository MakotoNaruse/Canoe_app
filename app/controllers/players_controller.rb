class PlayersController < ApplicationController
  before_action :forbid
  before_action :current

  def forbid
    if session[:univ_id] == nil
      redirect_to("/login")
    end
  end

  def current
    @current_univ = University.find_by(id: session[:univ_id])
    @year = Date.today.year
  end

  def index
    @players = Player.where(u_name: @current_univ.u_name).where(year: @year)
  end

  def add
    @player = Player.new(
      u_name: @current_univ.u_name,
      year: @year,
      p_name: params[:p_name],
      typ: params[:typ],
      grade: params[:grade].to_i
    )
    if params[:p_name].eql?("")
      flash[:notice] = "選手を追加できませんでした。内容を確認してください。"
    else
      if @player.save
        flash[:notice] = "選手を追加しました。"
      else
        flash[:notice] = "選手を追加できませんでした。内容を確認してください。"
      end
    end
    redirect_to("/players/index")
  end

  def edit
    @player = Player.find_by(id: params[:id])
    if @player == nil
      flash[:notice] = "権限がありません"
      redirect_to("/players/index")
    else
      if @player.u_name != @current_univ.u_name
        flash[:notice] = "権限がありません"
        redirect_to("/players/index")
      end
    end
  end

  def update
    if params[:p_name].eql?("")
      flash[:notice] = "選手を変更できませんでした。内容を確認してください。"
      redirect_to("/players/edit/#{params[:id]}")
    else
    @player = Player.find_by(id: params[:id])
    @player.p_name = params[:p_name]
    @player.typ = params[:typ]
    @player.grade = params[:grade].to_i
      if @player.save
        flash[:notice] = "選手を変更しました。"
        redirect_to("/players/index")
      else
        flash[:notice] = "選手を変更できませんでした。内容を確認してください。"
        render("players/edit")
      end
    end
  end

  def destroy
    @player = Player.find_by(id: params[:id])
    @player.destroy
    flash[:notice] = "選手を削除しました"
    redirect_to("/players/index")
  end

end
