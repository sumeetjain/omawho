class UsersController < ApplicationController
  skip_before_filter :require_login, :except => [:edit, :update, :destroy]
  
  def feed
    @feed_title = "#{@site_title}"
    @feed_items = User.order("created_at DESC")

    # Feed's update timestamp:
    @updated = @feed_items.first.created_at unless @feed_items.empty?

    respond_to do |format|
      format.atom { render :layout => false }

      # Redirect RSS permanently to ATOM.
      format.rss { redirect_to feed_path(:format => :atom), :status => :moved_permanently }
    end
  end
  
  # GET /users
  # GET /users.json
  def index
    User.connection.execute "select setseed(#{cookies[:random_seed]})"
    
    # Event -------------------------------------------------------------------
    if params[:event].present?
      gallery_event
    
    # Category ----------------------------------------------------------------
    elsif params[:category].present? && User::CATEGORIES[params[:category]].present?
      gallery_category
    
    # Home --------------------------------------------------------------------
    else
      gallery_home
    end
    
    # -------------------------------------------------------------------------
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
      format.js
    end
  end
  
  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find_by_username(params[:username])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    @image = Image.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    if current_user
      @user = current_user
      
      if @user.image
        @image = @user.image
      else
        @image = Image.new
      end
    else
      not_authenticated
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    @image = Image.new

    respond_to do |format|
      if @user.save
        auto_login(@user)
        format.html { redirect_to(:root, :notice => 'Thanks for adding your profile.') }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = current_user
    @image = @user.image

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to :profile, notice: 'Your profile has been updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = current_user
    @user.destroy

    respond_to do |format|
      format.html { redirect_to :logout }
      format.json { head :no_content }
    end
  end
  
private

  def gallery_home
    @page_title = "The Faces of #{@site_location}'s Creative Community"
    @page_description = "#{@site_title} shows basic profiles of the designers, programmers, decorators, photographers and other creatives in #{@site_location}."
    
    if params[:page].blank? || params[:page] == 1
      @gallery_type = "home"
    else
      @gallery_type = "page"
    end
    
    @users = User.random.page(params[:page]).per_page(12)
    
    active_categories = User.uniq.pluck(:category)
    @active_categories = User::CATEGORIES.select {|k,v| active_categories.include?(k)}
  end
  
  def gallery_category
    @page_title = "The Faces of #{@site_location}'s Creative Community - #{User::CATEGORIES[params[:category]]}"
    @page_description = "#{@site_title} shows basic profiles of the designers, programmers, decorators, photographers and other creatives in #{@site_location}."
    
    if params[:page].blank? || params[:page] == 1
      @gallery_type = "category"
    else
      @gallery_type = "page"
    end

    @users = User.random.where(:category => params[:category]).page(params[:page]).per_page(12)
    
    active_categories = User.uniq.pluck(:category)
    @active_categories = User::CATEGORIES.select {|k,v| active_categories.include?(k)}
  end
  
  def gallery_event
    @event = Event.find_by_slug(params[:event])
    
    if @event.approved?
      show_event = true
    elsif current_user && current_user.admin?
      show_event = true
    else
      show_event = false
    end
    
    if show_event
      if params[:page].blank? || params[:page] == 1
        @gallery_type = "event"
      else
        @gallery_type = "page"
      end
      
      @page_title = "Who's Attending #{@event.name}"     
      @page_description = "#{@site_location} creatives who are attending #{@event.name} on #{@event.date.to_s(:full)}."
      @blurb = "Put faces to names at #{@event.name}"
      
      # If category is also set:
      if params[:category].present? && User::CATEGORIES[params[:category]].present?
        @users = User.random.where(:id => @event.user_ids, :category => params[:category]).page(params[:page]).per_page(12)
      else
        @users = User.random.where(:id => @event.user_ids).page(params[:page]).per_page(12)
      end
      
      active_event_categories = @event.users.pluck(:category)
      @active_categories = User::CATEGORIES.select {|k,v| active_event_categories.include?(k)}
    else
      redirect_to :events
    end
  end
end