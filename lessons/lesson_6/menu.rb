# frozen_string_literal: true

require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'passenger_train'
require_relative 'passenger_wagon'
require_relative 'route'
require_relative 'station'
require_relative 'train'
require_relative 'wagon'

class Menu
  def initialize
    @stations = []
    @routes = []
  end

  def show_menu
    available_options = [
      '- Press 1 to create station',
      '- Press 2 to create train',
      '- Press 3 to create route or add/delete stations in the route',
      '- Press 4 to add route to the train',
      '- Press 5 to add wagon to the train',
      '- Press 6 to remove wagon from the train',
      '- Press 7 to move train from one station to another',
      '- Press 8 to see see stations and trains on them',
      '- Press 0 to exit from the program'
    ]

    loop do
      puts 'What do you want to do?'
      available_options.each { |option| puts option }
      choice = gets.chomp.to_i
      case choice
      when 1
        station_create
      when 2
        train_create
      when 3
        route_menu
      when 4
        add_route_to_train
      when 5
        add_wagon_to_train
      when 6
        remove_wagon_from_train
      when 7
        move_train
      when 8
        show_stations
      when 0
        exit
      else
        next
      end
    end
  end

  private

  def station_create
    puts 'Type title/name of the new station'
    station_title = gets.chomp
    station = Station.new(station_title)
    @stations << station
    puts "#{station} was created"
  end

  def find_station_by_title(title)
    @stations.find { |station| station.title == title }
  end

  def train_create
    puts 'Type train number'
    train_number = gets.chomp
    puts 'Which type of the train do you want to create. \'P\' for passenger and \'C\' for cargo'
    choice = gets.chomp.upcase
    case choice
    when 'P'
      train = PassengerTrain.new(train_number)
    when 'C'
      train = CargoTrain.new(train_number)
    else
      puts 'Error. You type wrong type'
      return
    end
    puts "#{train} was created"
  end

  def route_menu
    unless @stations.size >= 2
      puts 'Error. First create two or more stations'
      return
    end

    puts 'Type title of starting station'
    first_station_title = gets.chomp
    puts 'Type title of ending station'
    last_station_title = gets.chomp

    first_station = find_station_by_title(first_station_title)
    last_station = find_station_by_title(last_station_title)
    unless first_station && last_station
      puts 'Error. One or two such stations do not exist'
      return
    end

    route = Route.new(first_station, last_station)
    @routes << route
    puts "#{route} was created"

    loop do
      puts 'If you want add station to the route press \'A\', if you want to delete station press \'D\', if you want to exit press any other button'
      choice = gets.chomp.upcase
      case choice
      when 'A'
        puts 'Type title of the station'
        station_title = gets.chomp
        station = find_station_by_title(station_title)
        if station
          route.add_intermediate_station(station)
          puts "#{station_title} was successfully added to the #{route}"
        else
          puts "#{station_title} not found"
        end
      when 'D'
        puts 'Type title of the station'
        station_title = gets.chomp
        station = find_station_by_title(station_title)
        if route.stations.include?(station)
          route.stations.delete(station)
          puts "#{station_title} was successfully deleted from the #{route}"
        else
          puts "#{station_title} not found in the route"
        end
      else
        break
      end
    end
  end

  def add_route_to_train
    unless @routes.any?
      puts 'Error. There are not any routes'
      return
    end

    puts 'Type train number'
    train_number = gets.chomp
    train = Train.find(train_number)
    unless train
      puts 'Error. This train is not exist'
      return
    end

    puts 'Type number of the route that you want to add to the train'
    # increase index to make more habitual to people format
    @routes.each.with_index { |route, index| puts "№#{index + 1}. route with stations #{route.stations.map(&:title)}" }
    number = gets.chomp.to_i - 1
    route = @routes[number]
    if route
      train.get_route(route)
      puts 'Train successfully get route'
    else
      puts 'Error. You type wrong number of the route'
    end
  end

  def add_wagon_to_train
    puts 'Type train number'
    train_number = gets.chomp
    train = Train.find(train_number)
    unless train
      puts 'Error. This train is not exist'
      return
    end

    puts 'Which type of the wagon do you want to add? \'P\' for passenger and \'C\' for cargo'
    choice = gets.chomp.upcase
    case choice
    when 'P'
      wagon = PassengerWagon.new
    when 'C'
      wagon = CargoWagon.new
    else
      puts 'Error. You type wrong type'
      return
    end

    if train.add_wagon(wagon)
      puts 'Train and wagon are successfully connected'
    else
      puts 'Error. Incompatible types of train and wagon'
    end
  end

  def remove_wagon_from_train
    puts 'Type train number'
    train_number = gets.chomp
    train = Train.find(train_number)
    unless train
      puts 'Error. This train is not exist'
      return
    end

    unless train.wagons.any?
      puts 'Train doesn\'t have any wagons'
      return
    end

    puts 'Type number of the wagon that you want remove from the train'
    # increase index to make more habitual to people format
    train.wagons.each.with_index { |_, index| puts "№#{index + 1} Wagon" }
    number = gets.chomp.to_i - 1
    wagon = train.wagons[number]
    if wagon
      train.remove_wagon(wagon)
      puts 'Wagon was successfully removed'
    else
      puts 'Error. You type wrong number of the wagon'
    end
  end

  def move_train
    puts 'Type train number'
    train_number = gets.chomp
    train = Train.find(train_number)
    unless train
      puts 'Error. This train is not exist'
      return
    end

    if train.route.nil?
      puts 'Train don\'t have any routes, first add it.'
      return
    end

    puts 'In which side do you want to move the train? \'F\' - forward, \'B\' - back.'
    side = gets.chomp.upcase
    case side
    when 'F'
      if train.move_to_next_station
        puts 'Choo-choo, moved to the next station'
      else
        puts 'Error. Something went wrong'
      end
    when 'B'
      if train.move_to_previous_station
        puts 'Choo-choo, moved to the previous station'
      else
        puts 'Error. Something went wrong'
      end
    else
      puts 'Error. You type wrong option'
    end
  end

  def show_stations
    unless @stations.any?
      puts 'There are no any stations'
      return
    end

    puts 'Trains on which station do you want to see?'
    @stations.each.with_index { |station, index| puts "№#{index + 1} Station #{station.title}" }
    number = gets.chomp.to_i - 1
    station = @stations[number]
    if station
      unless station.trains.any?
        puts 'There are not any trains on the station'
        return
      end
      puts "There are trains at the station now: #{station.trains.map(&:train_number)}"
    else
      puts 'Error. You type wrong number of the station'
    end
  end
end
