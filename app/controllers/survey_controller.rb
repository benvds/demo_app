class SurveyController < ApplicationController
  def show
    @response = Response.new
  end

  def create_response
    @response = Response.new(response_params)

    if @response.save
      Notifier.delay.response(@response)

      redirect_to :survey_complete
    else
      render :show
    end
  end

  def complete
  end

  private

  def response_params
    params.require(:response).permit(:name, :email)
  end
end
