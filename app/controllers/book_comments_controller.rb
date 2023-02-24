class BookCommentsController < ApplicationController

  def create
    ## 投稿したbookの情報を取得する
    book = Book.find(params[:book_id])
    ## ストロングパラメーターでcommentへインスタンスの作成
    comment = BookComment.new(book_comment_params)
    ## コメントのユーザーIDとログインしているユーザーのIDを紐づける
    comment.user_id = current_user.id
    ## コメントの投稿IDと投稿しているIDを紐づける
    comment.book_id = book.id
    ## インスタンス生成したコメントを保存する
    comment.save
    ## 元の画面へ遷移する
    redirect_back fallback_location: root_path
  end

  def destroy
    ## コメントの情報をIDから取得する
    book = BookComment.find(params[:book_id])
    ## コメントを削除する
    book.destroy
    ## 元の画面へ遷移する
    redirect_back fallback_location: root_path
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end
