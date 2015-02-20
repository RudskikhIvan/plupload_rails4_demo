class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :edit, :update, :destroy]

  # GET /contents
  # GET /contents.json
  def index
    @contents = if (@tag = params[:tag].to_s.strip).present?
      Content.by_tag(@tag)
    else
      Content.all
    end
  end

  # GET /contents/1
  # GET /contents/1.json
  def show
    @title = @content.title
  end

  # GET /contents/new
  def new
    @content = Content.new
  end

  # POST /contents
  # POST /contents.json
  def create
    @content = Content.new(content_params)

    respond_to do |format|
      if @content.save
        format.html { redirect_to '/'}
        format.json { render json: {location: '/'}, status: :created }
      else
        format.html { render :new }
        format.json { render json: {errors: @content.errors} }
      end
    end
  end

  # DELETE /contents/1
  # DELETE /contents/1.json
  def destroy
    @content.destroy
    respond_to do |format|
      format.html { redirect_to contents_url, notice: "Файл #{@content.title} был удалён" }
      format.json { head :no_content }
    end
  end

  def download
    set_content
    send_file @content.file.path,
        :filename => "#{@content.title}#{File.extname(@content.file.path)}",
        :type => @content.file.content_type
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_content
      @content = Content.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def content_params
      params.permit(:title, :file, :tags)
    end

end
