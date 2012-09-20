class ReleasesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # GET /projects/:project_id/releases/1
  def show
    @project = Project.find_by_name(params[:project_id])
    @releases = ReleaseDecorator.find_all_by_project_id_and_version(@project, params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @release }
    end
  end

  # POST /projects/:project_id/releases
  # POST /projects/:project_id/releases.json
  def create
    @project = Project.find_or_create_by_name(params[:project_id])

    # old style
    if params[:release][:environment].is_a? String
      @environment = Environment.find_by_name(params[:release][:environment])
      params[:release].delete(:environment)
    end

    # new style
    if params[:environment].is_a? Hash
      @environment = Environment.find_or_initialize_by_deployment_host_and_destination(params[:environment][:deployment_host], params[:environment][:destination])
      @environment.update_attributes(params[:environment])
    end


    @release = Release.new(params[:release])
    @release.project = @project
    @release.environment = @environment

    respond_to do |format|
      if @release.save
        format.html { redirect_to [@project, @release], :notice => 'Release was successfully created.' }
        format.json { render :json => @release, :status => :created, :location => project_release_path(@release.project.name, @release) }
      else
        format.text { render :text => @release.errors }
        format.json { render :json => @release.errors, :status => :unprocessable_entity }
      end
    end
  end

end
