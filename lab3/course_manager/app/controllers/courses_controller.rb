# frozen_string_literal: true

class CoursesController < ApplicationController
  before_action :set_course, only: %i[show edit update destroy]

  def index
    @courses = Course.all
  end

  def active
    @courses = Course.active
  end

  def show; end

  def new
    @course = Course.new
    @categories = Category.pluck(:name)
  end

  def edit
    @categories = Category.pluck(:name)
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      redirect_to @course, notice: "Course was successfully created."
    else
      @categories = Category.pluck(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @course.update(course_params)
      redirect_to @course, notice: "Course was successfully updated."
    else
      @categories = Category.pluck(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @course.destroy
    redirect_to courses_url, notice: "Course was successfully destroyed."
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(
      :title, :category, :main_topic,
      :duration_hours, :start_date, :end_date,
      :price, :status
    )
  end
end
