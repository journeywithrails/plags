class AssetsController < ApplicationController
  
  def create
    @asset = Asset.new(params[:asset])
    @asset.data_content_type = MIME::Types.type_for(@asset.data_file_name).to_s

    respond_to do |format|
      if @asset.data_content_type.match(/image\/.+/) && @asset.save
        format.json { render :json => @asset.id }
      else
        format.json { render :json => "You may only upload images." }
      end
    end
  end
end
