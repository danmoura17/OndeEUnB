class ParserController < ApplicationController
  before_action :authenticate_admin!
  def index

    result = DownloadDepartaments.call
    puts result
    render plain: "Parse"
    #render plain: schedules
  end

  def geo_data
    '{"type":"FeatureCollection","features":[{"type":"Feature","properties":{},"geometry":{"type":"Polygon","coordinates":[[[-47.867375314235694,-15.762756116441665],[-47.86702126264573,-15.762497981882012],[-47.866597473621376,-15.763055552119592],[-47.8669622540474,-15.763303360622453],[-47.867375314235694,-15.762756116441665]]]}}]}'
  end

  def exclude_departments
    %w(FGA FCE FUP)
  end

  def allowed_buildings
    %w(ICC PAT PJC)
  end

  def replace_building_name(building)
    buildings = [ ['BSA N', 'BSAN'], ['BSA S', 'BSAS'] ]
    buildings.each do |replace|
      building.gsub(replace[0], replace[1])
    end
    building
  end

  def clean_room_name(room_name)
    room_name.delete('.', '')
    room_name
  end

  def define_room_type(room)
    if room.include? 'ANF'
      :amphitheater
    elsif room.include? 'LAB'
      :laboratory
    else
      :classroom
    end
  end

  def set_day_of_week(day_of_week)
    case day_of_week
    when 'Segunda'
      :monday
    when 'Terça'
      :tuesday
    when 'Quarta'
      :wednesday
    when 'Quinta'
      :thursday
    when 'Sexta'
      :friday
    when 'Sábado'
      :saturday
    when 'Domingo'
      :sunday
    end
  end

  def valid_schedule_and_room?(day_of_week, start_time, end_time, room, classroom)
    valid_times = day_of_week.present? && start_time.present? && end_time.present?
    valid_room = room.present? && (room != 'Local a Designar') && classroom.present?
    valid_times && valid_room
  end
  # Data parser


  def create_schedule(params)
    room = create_room(params)
    Schedule.where(room: room, day_of_week: params[:day_of_week], start_time: params[:start_time], end_time: params[:end_time]).first_or_create do |schedule|
      schedule.title = params[:course][:title]
      schedule.code = 0
      schedule.classroom = params[:classroom]
    end
  end

  def create_room(params)
    Room.where(acronym: params[:room]).first_or_create do |room|
    room.building = create_building(params)
    room.title = params[:room]
    room.room_type = params[:room_type]
    room.level = 0
    room.latitude = 0
    room.longitude = 0
    room.geo_data = geo_data
   end
  end

  def create_building(params)
    Building.where(acronym: params[:building]).first_or_create do |building|
      building.title = params[:building]
      building.acronym = params[:building]
      building.latitude = 0
      building.longitude = 0
      building.phone = 0
      building.geo_data = geo_data
    end
  end
end
