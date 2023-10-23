class HomeController < ApplicationController

  skip_before_action :authenticate_user!, only: [:up]

  def landing_page
  end

  def up
    render 'up', layout: false
  end

end
