class DownloadSchedules
  include Interactor

  def call
    require 'nokogiri'
    require 'open-uri'

    uri = open(context.url)
    html = Nokogiri::HTML(uri, nil, Encoding::UTF_8.to_s)
    classes = html.css('table#datatable')

    classes.shift

    # Getting the time and places of courses
    classes.each do |class_|
      #puts class_.content
      # next unless schedule_row.content.include? 'Total'
      class_name = class_.at_css('.turma').text
      class_.css('td[4] table').each do |schedule_data|
        day_of_week = schedule_data.at('td[1]').text
        start_time = schedule_data.at('td[2]').text
        end_time = schedule_data.at('td[3]').text
        room = schedule_data.at('tr[2] td[2]').text
      #
      #     next unless valid_schedule_and_room?(day_of_week, start_time, end_time, room, classroom)
      #     room = clean_room_name(room.text.strip)
      #
      #     building = replace_building_name(room.split.first).strip
      #
      #     next unless allowed_buildings.include? building
      #
        schedule = {
          # course: course,
          #day_of_week: set_day_of_week(day_of_week.text),
          start_time: start_time,
          end_time: end_time,
          # building: building,
          room: room,
          #room_type: define_room_type(room),
          #classroom: classroom.text
        }
      #
      #     puts schedule_data
      #     create_schedule(schedule_data)
      #   end
      end
    end
 end
end
