class DownloadCourses
  include Interactor

  def call
    require 'nokogiri'
    require 'open-uri'

    department = context
    uri = open(department.url)
    html = Nokogiri::HTML(uri, nil, Encoding::UTF_8.to_s)

    # get the third table of the page
    courses_rows = html.css('table#datatable tr')

    # skip table header
    courses_rows.shift

    # Getting courses data
    courses_rows.each do |course_row|
      course_data = course_row.at('td[2] a')
      title = course_data.text
      url = "https://matriculaweb.unb.br/graduacao/#{course_data['href']}"

      course = {
        title: title,
        url: url
      }

      DownloadSchedulesJob.perform_later course
    end
  end
end
