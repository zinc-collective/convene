class GuidesController < ApplicationController
  def index

  end

  def show

  end

  helper_method def guide
    @guide ||= Guide.find_by!(id: params[:id].to_sym)
  end

  helper_method def guides
    @guides ||= Guide.all
  end
end