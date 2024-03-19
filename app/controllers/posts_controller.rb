class PostsController < ApplicationController
  def create

    @chat = Chat.find(params[:chat_id])
    @post = Post.new(post_params)
    @post.chat = @chat
    @post.user = current_user
    authorize @post
    if @post.save
      ChatChannel.broadcast_to(
        @chat,
        render_to_string(partial: "post", locals: {post: @post})
      )
      head :ok
    else
      render "emergencies/chats/show", status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
