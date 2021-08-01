class AccountsController < ApplicationController
  before_action :forbid
  before_action :current

  def forbid
    if session[:op_id] == nil
      redirect_to("/operations/login")
    elsif session[:op_id] >= 5
      redirect_to("/operations/top")
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

  def index
    if @current_op.id <= 2
      @universities = University.all.order("erea DESC, id")
    elsif @current_op.id == 3
      @universities = University.where(erea: "関西").order(:id)
    elsif @current_op.id == 4
      @universities = University.where(erea: "関東").order(:id)
    end
  end

  def add
    @university = University.new(
      u_name: params[:u_name],
      read: params[:read],
      erea: params[:erea],
      password: params[:password]
    )
    if @university.save
      flash[:notice] = "アカウントを追加しました。"
    else
      flash[:notice] = "アカウントを追加できませんでした。内容を確認してください。"
    end
    redirect_to("/operations/accounts/index")
  end

  def edit
    @university = University.find_by(id: params[:id])
    if @university == nil
      flash[:notice] = "大学が存在しません"
      redirect_to("/operations/accounts/index")
    end
  end

  def update
    @university = University.find_by(id: params[:id])
    @university.u_name = params[:u_name]
    @university.read= params[:read]
    @university.erea = params[:erea]
    @university.password = params[:password]
    if @university.save
      flash[:notice] = "大学アカウント情報を変更しました。"
      redirect_to("/operations/accounts/index")
    else
      flash[:notice] = "変更できませんでした。内容を確認してください。"
      render("operations/accounts_edit")
    end
  end

  def reset_password
    @university = University.find_by(id: params[:id])
    if @university.blank?
      flash[:notice] = "大学が存在しません"
      redirect_to("/operations/accounts/index")
      return
    end
    
    #token発行
    @random_token = SecureRandom.urlsafe_base64(nil, false)

    @university.reset_token = @random_token

    if @university.save
      @reset_url = URI(request.base_url + '/reset_password')
      @reset_url.query = URI.encode_www_form({id: @university.id , token: @random_token })  
    else
      flash[:notice] = "URLの発行に失敗しました。もう一度やり直してください"
      redirect_to("/operations/accounts/index")
    end
  end

  def proxy_login
    @university = University.find_by(id: params[:id])
    if @university.blank?
      flash[:notice] = "大学が見つかりません"
      redirect_to("/operations/accounts/index")
      return
    end
    session[:univ_id] = @university.id
    flash[:notice] = "代理ログインしました"
    redirect_to("/reg/top")
  end
end
