class RecipesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_recipe, only: [:show, :edit, :update]
  before_action :authorize_record, only: [:edit, :update]

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    if @recipe.save
      flash[:notice] = "Recipe Sucessfully created"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def index
    @recipes = Recipe.all
  end

  def show
    @original_recipe = Recipe.find(@recipe.original_recipe_id.last) if @recipe.original_recipe_id.any?
  end

  def edit
  end

  def update
    if @recipe.update(recipe_params)
      flash[:notice] = "You have successfully edit recipe!"
      redirect_to recipe_path(@recipe)
    else
      flash[:alert] = @recipe.errors.full_messages.first
      render :edit
    end
  end

private

 def recipe_params
   recipe = params.require(:recipe).permit(:title, :description, :ingredients, :directions )
   recipe[:user] = current_user
   recipe
 end

 def get_recipe
    @recipe = Recipe.find(params[:id])
 end

 def authorize_record
    authorize @recipe
 end


end
