class DownloadCourses
  include Interactor

  def call
    require 'nokogiri'
    require 'open-uri'

    department = context
    uri = open(department.url)
    html = Nokogiri::HTML(uri, nil, Encoding::UTF_8.to_s)

    courses_rows = html.css('tbody tr')
    puts courses_rows.length

    # Getting courses data
    courses_rows.each do |course_row|
      course_data = course_row.at('td[2] a')
      title = course_data.text
      url = "https://matriculaweb.unb.br/graduacao/#{course_data['href']}"

      course = {
        department: department,
        title: title,
        url: url
      }
      puts course
      DownloadSchedulesJob.perform_later course
      # puts in the courses list course_data
      #courses.push(course_data)
    end
  end
end
