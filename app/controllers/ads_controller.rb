class AdsController < ApplicationController
  
   #~ prepend_before_filter :find_ads, :except => [ :index, :approve,:new,:create]
  
  
  #method for displaying all pending ads which are not approved
   def index
    @ads = Plagg.paginate(:page => params[:page], :conditions => "approved=0", :order => "created_at DESC")  
    respond_to do |format|
      format.html
    end
  end
  
  #method for approving an ad
  def approve
    plagg = Plagg.find(params[:id])
    plagg.approved = true
    plagg.update_attributes!(params[:plagg])
    flash[:notice] = "The ad has been published successfully"
    redirect_to :controller => 'ads' and return
  end
  
  def new
     @content = Content.new
  end
   
 #~ #method for adding Article details 
 def create

    $title = "Saving Article Details"
@content = Content.new(params[:content])
#~ render :text => "hi" and return
  if request.post? and @content.save
  @content= Content.new
 flash[:notice] ="successfully created"
  redirect_to :action => 'list'  and return
  else
  render :action => 'new' and return
 end
end


  def list
   $title = "Content List"
   @content = Content.find(:all, :order=>'contents.weight DESC')
  end
    
    
 # Method for Displaying Article Detaiils 
      def show
         $title = "Viewing the content details"
      @content = Content.find(params[:id])
      end
 
   #method for editing Article details
      def edit
         $title = "Editing the content details"
         @content = Content.find(params[:id])
      #~ @article= Article.find(params[:id])
      end
    
      #method for updating the Article details
      def update_faq
          $title = "Updating the content details"
         @content = Content.find(params[:id])
           if @content.update_attributes(params[:content])
           flash[:notice] = "The content  details was successfully updated"    
           redirect_to :action => 'list'
          else
          render :action => 'edit'
          end
        end
        
      #method to delete the Article   
      def delete
        $title = "deleting the Content details"
         @content = Content.find(params[:id])
         @content.destroy
            flash[:notice] ="successfully deleted"
            redirect_to :action => 'list' and return
      end
  
  
  #method for about us page
  def about
    @content = Content.find(:all)
  end
  

  
end
