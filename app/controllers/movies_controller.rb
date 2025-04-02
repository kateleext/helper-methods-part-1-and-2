class MoviesController < ApplicationController
  def new
    @movie = Movie.new
    render "movies/new"
  end

  def index
    matching_movies = Movie.all

    @movie = matching_movies.order({ created_at: :desc })

    respond_to do |format|
      format.json do
        render json: @movie
      end

      format.html do
        render "movies/index"
      end
    end
  end

  def show
    @movie = Movie.find(params.fetch(:id))
  end

  def create
    movie_attributes = params.require(:movie).permit(:title,:description)
    @movie = Movie.new(movie_attributes)
    

    if @movie.valid?
      @movie.save
      redirect_to(movies_url, { notice: "Movie was successfully created." })
    else
      render "movies/new"
    end
  end

  def edit
    @movie = Movie.find(params.fetch(:id))
  end

  def update
    movie = Movie.find(params.fetch(:id))
    attributes = params.require(:movie).permit(:title, :description)
    movie.update(attributes)

    if movie.valid?
      movie.save
      redirect_to(movie_url(movie), { notice: "Movie updated successfully." })
    else
      redirect_to(movie_url(movie), { alert: "Movie failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch(:id)
    movie = Movie.where({ id: the_id }).first

    movie.destroy

    redirect_to(movies_url, { notice: "Movie deleted successfully." })
  end
end
