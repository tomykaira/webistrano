class StylesheetsController < ApplicationController
  
  skip_before_filter :authenticate_user!
  caches_page :application
  
  def application
    render :content_type => 'text/css', :layout => false
  end
  
end
