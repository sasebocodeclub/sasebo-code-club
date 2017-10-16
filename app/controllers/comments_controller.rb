class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_post, only: [:index, :create]

  def index
    @comment = @post.comments
  end

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      flash[:success] = "Thank you for taking the time to leave a comment!"
      redirect_to post_path(@post)
    else
      flash[:alert] = "Something went wrong! Please try again or contact support."
      render :new
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:body)
    end

    def set_post
      @post = Post.find(params[:post_id])
    end
end
