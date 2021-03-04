class PostsController < ApplicationController
  before_action :authenticate_member!, only: [:new, :create]
  before_action :set_post, only: [:destroy]

  def index
    @posts = Post.all.order("created_at DESC")
  end

  def new
    @post = current_member.posts.build
  end

  def create
    @post = current_member.posts.build(post_params)
    if @post.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  def destroy
    # prevent deletion of another member's post unless logged in as that member
    # delete link is hidden in view. This prevents @post deletions using curl requests
    if correct_member
      @post.destroy
      flash[:success] = "Post deleted."
    end
    redirect_to root_path
  end

  private

    def post_params
      params.require(:post).permit(:content)
    end

    def set_post
      @post = Post.find(params[:id])
    end

    def correct_member
      current_member == @post.member
    end
end
