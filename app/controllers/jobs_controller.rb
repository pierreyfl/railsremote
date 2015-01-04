class JobsController < ApplicationController
  def index
    @jobs = Job.visible.newest_first
  end

  def show
    @job = Job.find(params[:id])
  end

  def edit
    @job = safe_find_job
  end

  def new

  end

  def create
    @job = Job.new(job_params)
    if @job.save
      handle_success
    else
      render action: :edit
    end
  end

  def update
    @job = safe_find_job
    if @job.update_attributes(job_params)
      handle_success
    else
      render action: :edit
    end
  end

private

  def safe_find_job
    Job.where(id: params[:id], token: params[:token]).first!
  end

  def job_params
    job_params = params.require(:job).permit(
        :token, :title, :job_type, :company_name, :salary,
        :company_url, :email, :description, :how_to_apply,
        :agencies_ok, :timezone_preferences
    )
    job_params.merge!(published: params[:commit] != "Preview")
    job_params
  end

  def handle_success
    if @job.published
      redirect_to job_path(@job, token: @job.token), notice: "All done! This job will become public once our moderators approve it."
    else
      redirect_to job_path(@job, token: @job.token)
    end
  end
end
