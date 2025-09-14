class QuestionsController < ApplicationController
  def step1; end

  def step2
    session[:meat] = params[:meat]
  end

  def step3
    session[:seasoning] = params[:seasoning]
  end

  def result
    session[:feature] = params[:feature]

    @region = Region.find_by(
      meat: session[:meat],
      seasoning: session[:seasoning]
    )

    if @region
      Vote.create!(region: @region)
    end
  end
end
