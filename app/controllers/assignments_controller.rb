class AssignmentsController < ApplicationController
  def index
    @date = params[:date]
    @schedules = Schedule.where(date: @date).where(status: "ok")
    @assignments_yes, @assignments_no = @schedules.partition { |schedule| schedule.assignment }
  end

  def create
    schedule = Schedule.find(params[:schedule_id])
    assignment = Assignment.new(schedule: schedule)
    assignment.save

    redirect_to schedule_assignments_path(schedule.date)
  end

  def destroy
    schedule = Schedule.find(params[:schedule_id])
    assignment = Assignment.find_by(schedule: schedule)
    assignment.destroy

    redirect_to schedule_assignments_path(schedule.date)
  end
end
