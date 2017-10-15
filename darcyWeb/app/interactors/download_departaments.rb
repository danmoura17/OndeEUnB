class DownloadDepartaments
  include Interactor

  def call
    require 'nokogiri'
    require 'open-uri'
    uri = open('https://matriculaweb.unb.br/graduacao/oferta_dep.aspx?cod=1')
    html = Nokogiri::HTML(uri, nil, Encoding::UTF_8.to_s)
    departments_rows = html.css('tbody tr')
    departments_rows.shift
    departments = []

    departments_rows.each do |department_row|
      acronym = department_row.at('td[2]').text
      department_data = department_row.at('td[3] a')
      title = department_data.text
      url = "https://matriculaweb.unb.br/graduacao/#{department_data['href']}"

      department = {
        acronym: acronym,
        title: department_data.text,
        url: url
      }

      DownloadCoursesJob.perform_later department
    end

    #departments
  end
end
