class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :verified_user?, only: [:new]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all
  end

  def show
  end

  def new
    if verified_user?
      @post = Post.new
    else
      flash[:alert] = "You must be a verifed user to post articles here. If you \
        feel you are receiving this alert in error, please contact support."
      redirect_to posts_path
    end
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      flash[:success] = "Thank you for taking the time to write a post!"
      redirect_to post_path(@post)
    else
      flash[:alert] = "Something went wrong! Please try again or contact support."
      render :new
    end
  end

  def edit
    redirect_to post_path(@post),
      notice: 'You don\'t have the proper permissions to update this post.' \
        unless current_user == @post.user
  end

  def update
    if @post.update_attributes(post_params)
      flash[:success] = "Your post has been updated!"
      redirect_to post_path(@post)
    else
      flash[:alert] = "Something went wrong! Try again or contact support."
      render :edit
    end
  end

  def destroy
    if @post.destroy
      flash[:success] = "Hopefully you wanted to destroy that article, because
        you just did."

      redirect_to posts_path
    else
      flash[:alert] = "Something went wrong. If you really want to try again or
        contact support."
    end
  end

  private
    def post_params
      params.require(:post).permit(:title, :body)
    end

    def set_post
      @post = Post.find(params[:id])
    end

    def verified_user?
      current_user.verified
    end
end
