require 'json'
class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = []
    if user_signed_in?
      @posts = current_user.posts
    else
      @posts = Post.all
    end
    if params[:tag]
      tag = params[:tag]
      @posts = @posts.where(:tags =>  /^#{tag}$/i)
    end
    if params[:search]
      search = params[:search]
      @posts = @posts.where(:title => /#{search}/i)
    end
    @posts = @posts.order_by(created_at: :desc)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    if can? :create, Post
      @post = Post.new
    else
      redirect_to action: "index"
    end
  end

  # GET /posts/1/edit
  def edit
    if cannot? :update, @post
      redirect_to action: "index"
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params.except(:tags))
    @post.user = current_user
    @post.tags = post_params[:tags].split(',').map{ |tag| tag.strip }

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    @post = Post.new(post_params.except(:tags))
    @post.user = current_user
    @post.tags = post_params[:tags].split(',').map{ |tag| tag.strip }

    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    if can? :destroy, @post
      @post.destroy
      respond_to do |format|
        format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to action: "index"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :abstract, :content, :thumbnail, :tags)
    end
end
