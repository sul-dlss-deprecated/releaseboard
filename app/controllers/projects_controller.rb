class ProjectsController < ApplicationController
  before_filter :require_user!

  # GET /projects
  # GET /projects.json
  def index
    @projects = ProjectDecorator.all
    @releases = ReleaseDecorator.recent

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = ProjectDecorator.find_by_name(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @project }
    end
  end
end
