class FavoritesController < ApplicationController

  def create
    ## 投稿している情報をIDから取得する
    book = Book.find(params[:book_id])
    ## ログインしているユーザーが投稿したIDを参照にインスタンスを生成する
    favorite = current_user.favorites.new(book_id: book.id)
    ## いいねする
    favorite.save
    ## 元の画面へ遷移する
    redirect_back fallback_location: root_path
  end

  def destroy
    ## 投稿している情報をIDから取得する
    book = Book.find(params[:book_id])
    ## ログインしているユーザーが投稿されたものにいいねしているか検索する
    favorite = current_user.favorites.find_by(book_id: book.id)
    ## いいねを削除する
    favorite.destroy
    ## 元の画面へ遷移する
    redirect_back fallback_location: root_path
  end

end
