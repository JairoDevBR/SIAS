class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :botao]

  def home
  end

  def botao
    skip_authorization
  end
end
