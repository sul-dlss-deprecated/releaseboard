class ReleasesController < ApplicationController
  # GET /projects/:project_id/releases/1
  # GET /projects/:project_id/releases/1.json
  def show
    @release = ReleaseDecorator.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @release }
    end
  end

  # POST /projects/:project_id/releases
  # POST /projects/:project_id/releases.json
  def create
    @release = Release.new(params[:release])

    respond_to do |format|
      if @release.save
        format.html { redirect_to @release, :notice => 'Release was successfully created.' }
        format.json { render :json => @release, :status => :created, :location => project_release_path(@release.project.name, @release) }
      else
        format.html { render :action => "new" }
        format.json { render :json => @release.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/:project_id/releases/1
  # PUT /projects/:project_id/releases/1.json
  def update
    @release = Release.find(params[:id])

    respond_to do |format|
      if @release.update_attributes(params[:release])
        format.html { redirect_to @release, :notice => 'Release was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @release.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/:project_id/releases/1
  # DELETE /projects/:project_id/releases/1.json
  def destroy
    @release = Release.find(params[:id])
    @release.destroy

    respond_to do |format|
      format.html { redirect_to releases_url }
      format.json { head :no_content }
    end
  end
  
  def resolve_params
    resolve_id_field(:project_id, Project, :release)
    resolve_id_field(:environment_id, Environment, :release)
  end  
end
