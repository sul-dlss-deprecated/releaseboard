class NotificationsController < ApplicationController
  before_filter :check_for_cancel, :only => [:create, :update, :destroy]
  after_filter  :set_valid_header, :only => [:create, :update]
  
  # GET /notifications
  # GET /notifications.json
  def index
    @notifications = Notification.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @notifications }
    end
  end

  # GET /notifications/1
  # GET /notifications/1.json
  def show
    @notification = Notification.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @notification }
    end
  end

  # GET /notifications/new
  # GET /notifications/new.json
  def new
    @notification = Notification.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @notification }
    end
  end

  # GET /notifications/1/edit
  def edit
    @notification = Notification.find(params[:id])
    if request.xhr?
      render :layout => nil
    else
      render
    end
  end

  # POST /notifications
  # POST /notifications.json
  def create
    @notification = Notification.new(params[:notification])
    
    respond_to do |format|
      if @notification.save
        format.html { request.xhr? ? render(:template => 'notifications/show', :layout => nil) : redirect_to(@notification, :notice => 'Notification was successfully created.') }
        format.json { render :json => @notification, :status => :created, :location => @notification }
      else
        format.html { render :action => "new" }
        format.json { render :json => @notification.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /notifications/1
  # PUT /notifications/1.json
  def update
    @notification = Notification.find(params[:id])

    (success, notice) = @cancel ? 
      [true, 'Update canceled.'] : 
      [@notification.update_attributes(params[:notification]), 'Notification was successfully updated.']
      
    respond_to do |format|
      if success
        format.html { request.xhr? ? render(:template => 'notifications/show', :layout => nil) : redirect_to(@notification, :notice => notice) }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @notification.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy

    respond_to do |format|
      format.html { redirect_to notifications_url }
      format.json { head :no_content }
    end
  end
  
  def set_valid_header
    response['X-Valid-Model'] = (@notification.present? and @notification.valid?).inspect
  end
  
  def check_for_cancel
    @cancel = params[:cancel].present? ? true : false
    Rails.logger.info("CANCEL: #{@cancel.inspect}")
  end
end
