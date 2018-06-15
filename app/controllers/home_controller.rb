class HomeController < ApplicationController

  before_action :restrict_loggedin_user, only: :top

  def top
  end

  def about
  end
end
