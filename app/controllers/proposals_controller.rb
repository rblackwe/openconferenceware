class ProposalsController < ApplicationController

  before_filter :login_required, :only => [:edit, :update, :destroy]
  before_filter :assign_current_event, :only => [:new, :create]
  before_filter :redirect_unless_accepting_proposals, :only => [:new, :create]

  MAX_FEED_ITEMS = 20

  # GET /proposals
  # GET /proposals.xml
  def index
    case request.format.to_sym
    when :atom, :json, :xml
      @event = params[:event_id] ? Event.lookup(params[:event_id].to_i) : nil
    else
      return if assign_current_event
    end
    @proposals = @event ? @event.lookup_proposals : Proposal.lookup

    respond_to do |format|
      format.html {
        add_breadcrumb @event.title, event_proposals_path(@event)
      }
      format.xml  {
        render :xml => @proposals
      }
      format.json {
        render :json => @proposals
      }
      format.atom {
        @proposals = @proposals[0..MAX_FEED_ITEMS]
      }
      format.csv {
        buffer = StringIO.new
        CSV::Writer.generate(buffer) do |csv|
          fields = [
            :id,
            :submitted_at,
            :presenter,
            :affiliation,
            :url,
            :bio,
            :title,
            :description,
          ]
          if admin?
            fields << :email
            fields << :note_to_organizers
            fields << :comments_text
          end
          csv << fields.map{|field| field.to_s}
          for proposal in @proposals
            csv << fields.map{|field| value = proposal[field]; field == :created_at ? value.localtime.to_s(:date_time12) : value }
          end
        end
        buffer.rewind
        render :text => buffer.read
      }
    end
  end

  # GET /proposals/1
  # GET /proposals/1.xml
  def show
    #IK# unless @proposal = Proposal.find_by_id(params[:id])
    unless @proposal = Proposal.lookup(params[:id].ergo.to_i)
      flash[:failure] = "Sorry, that presentation proposal doesn't exist or has been deleted."
      return redirect_to(:action => :index)
    end
    @event = @proposal.event
    add_breadcrumb @event.title, event_proposals_path(@event)
    add_breadcrumb @proposal.title, proposal_path(@proposal)

    @comment = Comment.new(:proposal => @proposal, :email => current_email)
    @display_comment = ! params[:commented] && ! can_edit? && accepting_proposals?
    @focus_comment = false

    # TODO do not include private fields in the json/xml exports
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @proposal }
      format.json { render :json => @proposal }
    end
  end

  # GET /proposals/new
  # GET /proposals/new.xml
  def new
    add_breadcrumb @event.title, event_proposals_path(@event)
    add_breadcrumb "Create a proposal", new_event_proposal_path

    @proposal = Proposal.new
    if logged_in?
      @proposal.presenter = current_user.fullname
    end
    @proposal.email = current_email

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @proposal }
      format.json { render :json => @proposal }
    end
  end

  # GET /proposals/1/edit
  def edit
    @proposal = Proposal.find(params[:id])
    @event = @proposal.event
    add_breadcrumb @event.title, event_proposals_path(@event)
    add_breadcrumb @proposal.title, proposal_path(@proposal)

    return unless assert_ownership
  end

  # POST /proposals
  # POST /proposals.xml
  def create
    if params[:commit] == "Login" && params[:openid_url]
      store_location(new_proposal_path)
      #return render_component(:controller => "sessions", :action => "create", :openid_url => params[:openid_url])
      return redirect_to(url_for(:controller => "sessions", :action => "create", :openid_url => params[:openid_url]))
    end

    @proposal = Proposal.new(params[:proposal])
    @proposal.event = @event
    @proposal.user = current_user if logged_in?

    respond_to do |format|
      if @proposal.save
        flash[:success] = 'Proposal created.'
        format.html { redirect_to(@proposal) }
        format.xml  { render :xml => @proposal, :status => :created, :location => @proposal }
        format.json { render :json => @proposal, :status => :created, :location => @proposal }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @proposal.errors, :status => :unprocessable_entity }
        format.json { render :json => @proposal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /proposals/1
  # PUT /proposals/1.xml
  def update
    @proposal = Proposal.find(params[:id])
    @event = @proposal.event
    add_breadcrumb @event.title, event_proposals_path(@event)
    add_breadcrumb @proposal.title, proposal_path(@proposal)
    return unless assert_ownership

    respond_to do |format|
      if @proposal.update_attributes(params[:proposal])
        flash[:success] = 'Proposal was successfully updated.'
        format.html { redirect_to(@proposal) }
        format.xml  { head :ok }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @proposal.errors, :status => :unprocessable_entity }
        format.json { render :json => @proposal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /proposals/1
  # DELETE /proposals/1.xml
  def destroy
    @proposal = Proposal.find(params[:id])
    @event = @proposal.event
    return unless assert_ownership

    @proposal.destroy
    flash[:success] = "Destroyed proposal: #{@proposal.title}"

    respond_to do |format|
      format.html { redirect_to(event_proposals_path(@proposal.event)) }
      format.xml  { head :ok }
      format.json { head :ok }
    end
  end

protected

  def redirect_unless_accepting_proposals
    unless accepting_proposals?
      flash[:failure] = Snippet.content_for(:proposals_not_accepted_error)
      redirect_to @event ? event_proposals_path(@event) : proposals_path
    end
  end

  def assert_ownership
    if admin?
      return true
    else
      if accepting_proposals?
        if can_edit?
          return true
        else
          flash[:failure] = "You do not have permission to alter this proposal."
          redirect_to proposal_path(@proposal)
          return false
        end
      else
        flash[:failure] = "You cannot edit proposals after the submission deadline."
        redirect_to @event ? event_proposals_path(@event) : proposals_path
        return false
      end
    end
  end

end