class PostsController < ApplicationController
  before_action :authenticate_member!, only: [:new, :create]

  def new
    @post = current_member.posts.build
  end

  def index
    @posts = Post.all.order("created_at DESC")
  end
end
