class TicksController < ApplicationController

  skip_before_action :verify_authenticity_token

  before_action :verify_request_ip

  def index
    respond_to do |format|
      format.json {render json: {action: :buy}, status: :ok}
    end
  end

  def create
    log_data

    respond_to do |format|
      format.json {render json: {data: :completed}, status: :ok}
    end
  end

  private

  def log_data
    [:bid, :ask, :symbol, :timeframe, :volume].each do |param|
      logger.warn "#{param.upcase}: #{tick_params[param]}"
    end
  end

  def tick_params
    params.permit(:bid, :ask, :symbol, :timeframe, :volume)
  end

  def verify_request_ip
    unless Rails.application.secrets[:ip_whitelist].include? request.remote_ip
      render plain: 'Not Authorized', status: :unauthorized
    end
  end

end