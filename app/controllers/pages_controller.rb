class PagesController < ApplicationController

  def index
    @page = Page.find_by_permalink "home"

    if @page
      render :action => 'show'
    else
      redirect_to all_pages_path
    end
  end

  def show
    @page = Page.find_by_permalink(params[:permalink])

    if @page.nil?
      redirect_to new_page_path(:title => params[:permalink])
    end
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @page = Page.new(:title => params[:title])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])
  end

  # POST /pages
  # POST /pages.xml
  def create
    @page = current_user.pages.build(params[:page])

    respond_to do |format|
      if @page.save
        flash[:notice] = 'Seite wurde angelegt.'
        format.html { redirect_to(wiki_page_path(@page.permalink)) }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = Page.find(params[:id])

    if @page.update_attributes(params[:page].merge({:user => current_user}))
      flash[:notice] = 'Seite wurde aktualisiert.'
      redirect_to wiki_page_path(@page.permalink)
    else
      render :action => "edit"
    end

  rescue ActiveRecord::StaleObjectError
    flash[:error] = "Achtung, die Seite wurde gerade von jemand anderes bearbeitet. Bitte versuche es erneut."
    redirect_to wiki_page_path(@page.permalink)
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(pages_url) }
      format.xml  { head :ok }
    end
  end

  def all
    @pages = Page.all :order => 'created_at'
  end

  def version
    @page = Page.find(params[:id])
    @version = @page.versions[params[:version].to_i - 1]
  end

  def revert
    @page = Page.find(params[:id])
    @page.revert_to(params[:version].to_i)

    render :action => 'edit'
  end
end
