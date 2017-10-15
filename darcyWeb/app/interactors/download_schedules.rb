class DownloadSchedules
  include Interactor

  def call
    require 'nokogiri'
    require 'open-uri'

    uri = open(context.url)
    html = Nokogiri::HTML(uri, nil, Encoding::UTF_8.to_s)
    classes = html.css('tbody tr')

    # Getting the time and places of courses
    classes.each do |class_|
      puts class_.content
      # next unless schedule_row.content.include? 'Total'
      # classroom = schedule_row.at_css('td[1] b')
      # schedule_row.css('td[4] div').each do |schedule|
      #     day_of_week = schedule.at_css('b')
      #     start_time = schedule.at_css('font[color="black"] b')
      #     end_time = schedule.at_css('font[color="brown"]')
      #     room = schedule.at_css('i')
      #
      #     next unless valid_schedule_and_room?(day_of_week, start_time, end_time, room, classroom)
      #     room = clean_room_name(room.text.strip)
      #
      #     building = replace_building_name(room.split.first).strip
      #
      #     next unless allowed_buildings.include? building
      #
      #     schedule_data = {
      #       course: course,
      #       day_of_week: set_day_of_week(day_of_week.text),
      #       start_time: start_time.text,
      #       end_time: end_time.text,
      #       building: building,
      #       room: room,
      #       room_type: define_room_type(room),
      #       classroom: classroom.text
      #     }
      #
      #     puts schedule_data
      #     create_schedule(schedule_data)
      #   end
      # end
    end
 end
end
