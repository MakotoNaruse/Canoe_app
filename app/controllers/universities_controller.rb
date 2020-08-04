class UniversitiesController < ApplicationController
  before_action :current
  before_action :forbid_login_univ, {only: [:login_form, :login]}
  before_action :forbid_login, {only: [:top, :confirm, :choice_tour_form, :choice]}
  before_action :current_tour
  before_action :forbid_choice, {only: [:top, :confirm]}

  def forbid_login_univ
    if @current_univ
      flash[:notice] = "ログイン中です"
      redirect_to("/reg/top")
    end
  end

  def forbid_login
    if session[:univ_id] == nil
      redirect_to("/login")
    end
  end

  def current
    @current_univ = University.find_by(id: session[:univ_id])
    @year = Date.today.year
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

  def login_form
    # @university = University.new
  end

  def choice_tour_form

  end

  def choice
    if params[:tour].to_i >= 1 && params[:tour].to_i <= 3
      session[:tour_id] = params[:tour]
      flash[:notice] = "選択しました"
      redirect_to("/reg/top")
    else
      flash[:notice] = "選択できませんした"
      redirect_to("/reg/choice")
    end
  end

  def login
    @university = University.find_by(u_name: params[:u_name])
    if @university && @university.authenticate(params[:password])
      session[:univ_id] = @university.id
      flash[:notice] = "ログインしました"
      redirect_to("/reg/top")
    else
      @error_message = "大学名またはパスワードが違います"
      @u_name = params[:u_name]
      @password = params[:password]
      render("universities/login_form")
    end
  end

  def logout
    session[:univ_id] = nil
    session[:tour_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/")
  end

  def top

  end

  def confirm
    if Rails.env.production?
      @players = Player.where(u_name: @current_univ.u_name, year: @year).order({grade: :desc}, :typ).order('reading COLLATE "C" ASC')
    else
      @players = Player.where(u_name: @current_univ.u_name, year: @year).order({grade: :desc}, :typ).order(:reading)
    end
    @substitutes = Substitute.where(u_name: @current_univ.u_name).where(year: @year)
                              .where(tour: @current_tour_id)
    @fours = Four.where(university_id: @current_univ.id, tour: @current_tour_id, year: @year)
    respond_to do |format|
      format.html
      format.pdf do
        if @current_tour_id == 1
          @current_tour = "全日本学生カヌースプリント選手権大会"
        elsif @current_tour_id == 2
          @current_tour = "関西学生カヌー選手権大会"
        elsif @current_tour_id == 3
          @current_tour = "関東学生カヌースプリント選手権大会"
        end
        render pdf: 'entry_confirm', #pdfファイルの名前。これがないとエラーが出ます
               layout: 'pdf.html.erb',
               template: 'universities/confirm.pdf.erb', #テンプレートファイルの指定。viewsフォルダが読み込まれます。
               encording: 'UTF-8' # 日本語フォントを使用するために必要。
      end
    end
  end

  def password_token
    @university = University.find_by(id: params[:id])
    @token = params[:token]
    if @university.blank? || @token.blank?
      redirect_to("/")
      return
    end
    if @university.reset_token != @token
      redirect_to("/")
      return
    end
  end 

  def reset_password
    @university = University.find_by(id: params[:id])
    @token = params[:token]
    if @university.blank? || @token.blank?
      redirect_to("/")
      return
    end
    if @university.reset_token != @token
      redirect_to("/")
      return
    end
    @university.password = params[:password]
    @university.reset_token = nil
    if @university.save
      session[:univ_id] = @university.id
      flash[:notice] = "パスワードを変更しました"
      redirect_to("/reg/top")
    else
      flash[:notice] = "パスワードの変更に失敗しました。もう一度やり直してください。"
      render("universities/password_token")
    end
  end

end
