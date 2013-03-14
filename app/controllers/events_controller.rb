class EventsController < ApplicationController
  skip_before_filter :require_login, :except => [:edit, :update, :destroy]
  
  def attend
    @event = Event.find(params[:event_id])
    
    if current_user.events.exists?(@event)
      current_user.events.delete(@event)
    else
      current_user.events << @event
    end
    
    @user_events = current_user.events
    
    respond_to do |format|
      format.html { redirect_to event_path(@event.slug), notice: 'Your attendance status was updated.' }
      format.json { render json: @events }
      format.js
    end
  end
  
  # GET /events
  # GET /events.json
  def index
    if current_user && current_user.admin?
      @events = Event.where('date > ?', DateTime.now).order("date ASC")
      @past_events = Event.where('date < ?', DateTime.now).order("date DESC")
    else
      @events = Event.approved.where('date > ?', DateTime.now).order("date ASC")
      @past_events = Event.approved.where('date < ?', DateTime.now).order("date DESC")
    end
    
    if current_user
      @user_events = current_user.events
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    if current_user.admin?
      @event = Event.find(params[:id])
    else
      not_authenticated
    end
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to :events, notice: 'Request to add event received.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    if current_user.admin?
      @event = Event.find(params[:id])

      respond_to do |format|
        if @event.update_attributes(params[:event])
          format.html { redirect_to event_path(@event.slug), notice: 'Event was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      end
    else
      not_authenticated
    end
  end
  
  def approve
    if current_user.admin?
      @event = Event.find(params[:event_id])

      respond_to do |format|
        if @event.update_attribute(:approved, true)
          format.html { redirect_to :events, notice: 'Event approved.' }
          format.json { head :no_content }
        else
          format.html { redirect_to :events, alert: 'Error.' }
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      end
    else
      not_authenticated
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    if current_user.admin?
      @event = Event.find(params[:id])
      @event.destroy

      respond_to do |format|
        format.html { redirect_to events_url }
        format.json { head :no_content }
      end
    else
      not_authenticated
    end
  end
end
