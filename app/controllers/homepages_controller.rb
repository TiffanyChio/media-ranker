class HomepagesController < ApplicationController
  def index
    @spotlight = Work.spotlight
    @works = Work.all
  end
end
