class OperatorsController < ApplicationController
  before_action :forbid, {only: [:index, :edit, :update]}
  before_action :current
  before_action :forbid_login, {only: [:login_form, :login]}
  before_action :forbid_admin, {only: [:index, :edit, :update]}

  def forbid
    if session[:op_id] == nil
      redirect_to("/operations/login")
    end
  end

  def forbid_login
    if session[:op_id]
      redirect_to("/operations/top")
    end
  end

  def forbid_admin
    if session[:op_id].to_i != 1
      flash[:notice] = "権限がありません"
      redirect_to("/operations/top")
    end
  end

  def current
    @current_op = Operator.find_by(id: session[:op_id])
    @year = Date.today.year
  end

  def login_form
  end

  def login
    @operator = Operator.find_by(name: params[:name], password: params[:password])
    if @operator
      session[:op_id] = @operator.id
      flash[:notice] = "ログインしました"
      redirect_to("/operations/top")
    else
      @error_message = "アカウント名またはパスワードが違います"
      @name = params[:name]
      @password = params[:password]
      render("operators/login_form")
    end
  end

  def logout
    session[:op_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/")
  end

  def index
    @operators = Operator.all
  end

  def edit
    @operator = Operator.find_by(id: params[:id])
    if @operator == nil
      flash[:notice] = "エラー"
      redirect_to("/operators/index")
    end
  end

  def update
    @operator = Operator.find_by(id: params[:id])
    @operator.password = params[:password]
    if @operator.save
      flash[:notice] = "パスワードを変更しました"
    else
      flash[:notice] = "パスワードを変更できませんでした"
    end
    redirect_to("/operators/index")
  end
end
