class UsersController < ApplicationController

  before_action :authenticate_user, {only: [:index, :show, :edit, :update]}
  before_action :restrict_loggedin_user, {only: [:new, :create, :login_form, :login]}
  before_action :check_correct_user, {only: [:edit, :update]}

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(name: params[:name],
                     email: params[:email],
                     image_name: "default_user.jpg",
                     password: params[:password])
    @user.save
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "You are successfully registered"
      redirect_to("/users/#{@user.id}")
    else
      render("users/new.html.erb")
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]

    if params[:image]
      @user.image_name = "#{@user.id}.jpg"
      image = params[:image]
      File.binwrite("public/user_images/#{@user.image_name}", image.read)
    end

    if @user.save
      flash[:notice] = "Successfully updated"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit.html.erb")
    end
  end

  def login_form
  end

  def login
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user
      flash[:notice] = "You are successfully logged in"
      session[:user_id] = @user.id
      redirect_to("/posts/index")
    else
      @error_message = "The data you entered are invalid"
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "Successfully logged out"
    redirect_to("/login")
  end

  def check_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "You are not allowed to do that"
      redirect_to("/posts/index")
    end
  end
end
