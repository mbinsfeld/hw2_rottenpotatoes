class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if (params[:ratings] == nil and session[:ratings] !=nil) or 
              (params[:order] == nil and session[:ratings] != nil)
      if params[:order] == nil and session[:order] != nil
        params[:order] = session[:order]
      end 
      if params[:ratings] == nil and session[:ratings] != nil
        params[:ratings] = session[:ratings]
      end
      redirect_to movies_path(:order => params[:order], :ratings => params[:ratings])
    end
    @all_ratings = Movie.ratings
    @ratings = params[:ratings]
    if @ratings == nil
      @movies = Movie.find(:all, :order => params[:order])
    else
       @ratings = @ratings.keys
       @movies = Movie.find(:all, :conditions =>{:rating => (@ratings == [] ? @all_ratings : @ratings)}, :order => params[:order])
    end
   
    if params[:order] == "title"
      @title_header = "hilite"
    end
    if params[:order] == "release_date"
      @release_date_header = "hilite"
    end
    if @ratings != nil
      @checker = @ratings

    else
      @checker = []
    end
    session[:order] = params[:order]
    session[:ratings] = params[:ratings]
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
