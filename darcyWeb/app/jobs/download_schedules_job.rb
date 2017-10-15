class DownloadSchedulesJob < ApplicationJob
  queue_as :default

  def perform(department)
    result = DownloadSchedules.call(department)
  end
end
