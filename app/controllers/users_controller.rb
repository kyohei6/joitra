class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :edit, :update, :followings, :followers, :likes, :profiles]
  
  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(id: :desc).page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to login_url
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  def edit
  @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if current_user == @user
      if @user.update(user_params)
        flash[:success] = 'ユーザー情報を編集しました。'
        render :edit
      else
        flash.now[:danger] = 'ユーザー情報の編集に失敗しました。'
        render :edit
      end   
    else
    redirect_to root_url
    end
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  def likes
    @user = User.find(params[:id])
    @likes = @user.likes.page(params[:page])
    counts(@user)
  end
  
  def profiles
    @user = User.find(params[:id])
  end
  
  def chats
    @user = User.find(params[:id])
        #チャット
        if logged_in?
            #Entry内のuser_idがcurrent_userと同じEntry
            @currentUserEntry = Entry.where(user_id: current_user.id)
            #Entry内のuser_idがMYPAGEのparams.idと同じEntry
            @user = User.find(params[:id])
            @userEntry = Entry.where(user_id: @user.id)
                #@user.idとcurrent_user.idが同じでなければ
                unless @user.id == current_user.id
                  @currentUserEntry.each do |cu|
                    @userEntry.each do |u|
                      #もしcurrent_user側のルームidと＠user側のルームidが同じであれば存在するルームに飛ぶ
                      if cu.room_id == u.room_id then
                        @isRoom = true
                        @roomId = cu.room_id
                      end
                    end
                  end
                  #ルームが存在していなければルームとエントリーを作成する
                  unless @isRoom
                    @room = Room.new
                    @entry = Entry.new
                  end
                end
        end
  end
  
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :age, :sex, :address, :gym, :reason, :history, :introduce)
  end
end
