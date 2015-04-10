class ReleasesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # GET /projects/:project_id/releases/1
  def show
    @project = Project.find_by_name(params[:project_id])
    @releases = Release.where(project_id: @project, version: params[:id]).decorate

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @release }
    end
  end

  # POST /projects/:project_id/releases
  # POST /projects/:project_id/releases.json
  def create
    @project = Project.find_or_create_by name: params[:project_id]
    
    env = params[:environment] || params[:release][:environment]

    # old style
    if env.is_a? String
      @environment = Environment.find_or_create_by(name: env)
      params[:release].delete(:environment)
    end

    # new style
    if env.is_a? Hash
      @environment = Environment.find_or_initialize_by deployment_host: env[:deployment_host], destination: env[:destination]
      @environment.update_attributes(environment_params)
    end


    @release = Release.new(release_params)
    @release.project = @project
    @release.environment = @environment

    respond_to do |format|
      if @release.save!
        format.html { redirect_to [@project, @release], :notice => 'Release was successfully created.' }
        format.json { render :json => @release, :status => :created, :location => project_release_path(@release.project.name, @release) }
      else
        format.html { render :text => @release.errors }
        format.text { render :text => @release.errors }
        format.json { render :json => @release.errors, :status => :unprocessable_entity }
      end
    end
  end

  protected

  def environment_params
    params.require(:environment).permit(:deployment_host, :destination, :name)
  end

  def release_params
    params.require(:release).permit(:project_id, :environment_id, :version, :released_by, :released_at, :link, :release_notes, :repository, :branch, :sha)
  end

end
