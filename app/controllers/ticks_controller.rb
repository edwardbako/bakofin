class TicksController < ApplicationController

  def index
    puts request.body
    respond_to do |format|
      format.json {render json: {action: :buy}, status: :ok}
    end
  end


end