class PrototypesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_prototype, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]


  def new
    @prototype = Prototype.new
  end

  def index
    @prototypes = Prototype.includes(:user)
  end 

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to prototype_path(@prototype), notice: "投稿が完了しました"
    else
      render :new
    end
  end
  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)

  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype), notice: "投稿が更新されました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
  redirect_to prototypes_path, notice: "投稿が削除されました"
  end

  private
  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  def authorize_user!
    unless current_user == @prototype.user
      redirect_to root_path
    end
  end


  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end
end