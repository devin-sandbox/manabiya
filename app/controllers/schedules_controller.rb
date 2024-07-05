class SchedulesController < ApplicationController
  def index
    @dates = Date.today.upto(Date.today + 14.days).reject { _1.wday.in?([0, 6]) }
    @schedules = Schedule.where("date >= ?", Date.today)
  end

  def create
    schedules_params = params[:schedules].map do |schedule_params|
      schedule_params.permit(:date, :status, :memo).tap do |sp|
        sp[:status] = sp[:status].to_i if sp[:status].present?
      end
    end

    schedules_params.each do |schedule_param|
      next if schedule_param[:status].blank?
      schedule = current_member.schedules.find_or_initialize_by(date: schedule_param[:date])
      schedule.update(schedule_param)
    end

    redirect_to schedules_path
  end

  def update
    schedule = current_member.schedules.find_by(date: params[:schedule][:date])
    schedule.update(schedule_params)

    redirect_to schedules_path
  end

  def schedule_params
    params.require(:schedule).permit(:date, :status, :memo).tap do |schedule_params|
      schedule_params[:status] = schedule_params[:status].to_i
    end
  end
end
