module BusinessAdmins
  class ReportsController < ApplicationController
    before_action :authenticate_business_admin!
    before_action :set_report, only: [:show, :edit, :update, :destroy]

    def index
      @reports = Report.all
    end

    def show; end

    def new
      @report = Report.new
    end

    def create
      @report = Report.new(report_params)
      if @report.save
        redirect_to business_admins_report_path(@report), notice: 'Report created successfully.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @report.update(report_params)
        redirect_to business_admins_report_path(@report), notice: 'Report updated successfully.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @report.destroy
      redirect_to business_admins_reports_path, notice: 'Report deleted successfully.'
    end

    private

    def set_report
      @report = Report.find(params[:id])
    end

    def report_params
      params.require(:report).permit(:title, :description, :report_type, :store_id)
    end
  end
end