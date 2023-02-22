class BooksController < ApplicationController
  before_action :is_maching_book_user, only: [:edit, :update]
  
  def index
    @user = current_user
    @book = Book.new
    @books = Book.all
  end
  
  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "Book create successfuly"
      redirect_to book_path(@book)
    else
      @user = current_user
      @books = Book.all
      render "index"
    end
  end

  def show
    @book_show = Book.find(params[:id])
    @book = Book.new
    @user = @book_show.user
  end

  def edit
    @book = Book.find(params[:id])
  end
  
  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "Book update successfuly"
      redirect_to book_path(@book)
    else
      render "edit"
    end
  end
  
  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end
  
  private
  
  def is_maching_book_user
    book = Book.find(params[:id])
    unless book.user == current_user
      redirect_to book_path(book)
    end
  end
  
  def book_params
    params.require(:book).permit(:title, :body)
  end
end
