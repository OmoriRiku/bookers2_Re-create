class FavoritesController < ApplicationController

  def create
    ##　本の投稿のIDをURLから取得する。
    book = Book.find(params[:book_id])
    ## ログインしているユーザーのFavoriteテーブルからいいねする投稿のIDのインスタンスを生成する。
    favorite = current_user.favorites.new(book_id: book.id)
    ## いいねする
    favorite.save
    ## 元の画面へ遷移する
    redirect_back fallback_location: root_path
  end

  def destroy
    ## 本の投稿のIDをURLから取得する。
    book = Book.find(params[:book_id])
    ## ログインしているユーザーのFavoriteテーブルからいいねした投稿のIDを取得する。
    favorite = current_user.favorites.find_by(book_id: book.id)
    ## いいねを削除する
    favorite.destroy
    ## 元の画面へ遷移する
    redirect_back fallback_location: root_path
  end

end
