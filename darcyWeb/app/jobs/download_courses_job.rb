class DownloadCoursesJob < ApplicationJob
  queue_as :default

  def perform(department)
    DownloadCourses.call(department)
  end
end
