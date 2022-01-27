# frozen_string_literal: true

require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'passenger_train'
require_relative 'passenger_wagon'
require_relative 'route'
require_relative 'station'
require_relative 'train'
require_relative 'wagon'

# === Menu ===
class Menu
  def initialize
    @stations = []
    @routes = []
  end

  # rubocop:disable Metrics/MethodLength
  def show_menu
    loop do
      puts 'What do you want to do?'
      available_options.each { |option| puts option }
      choice = gets.chomp.to_i
      case choice
      when 1
        station_create
      when 2
        create_train
      when 3
        route_menu
      when 4
        add_route_to_train
      when 5
        wagon_menu
      when 6
        move_train
      when 7
        show_stations
      when 0
        exit
      else
        next
      end
    end
  end

  def seed
    puts 'Seeding...'
    passenger_train = PassengerTrain.new('555-ac')
    passenger_wagon = PassengerWagon.new(50)
    passenger_train.add_wagon(passenger_wagon)

    cargo_train = CargoTrain.new('k1348')
    cargo_wagon = CargoWagon.new(400)
    cargo_train.add_wagon(cargo_wagon)

    spb = Station.new('Saint-Petersburg')
    msk = Station.new('Moscow')
    @stations += [spb, msk]

    route = Route.new(spb, msk)
    @routes << route

    passenger_train.get_route(route)
    cargo_train.get_route(route)
    puts 'Seeding is ended'
  end
  # rubocop:enable Metrics/MethodLength

  private

  def available_options
    [
      '- Press 1 to create station',
      '- Press 2 to create train',
      '- Press 3 to create route or add/delete stations in the route',
      '- Press 4 to add route to the train',
      '- Press 5 to open wagon menu',
      '- Press 6 to move train from one station to another',
      '- Press 7 to see see stations and trains on them',
      '- Press 0 to exit from the program'
    ]
  end

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

  def create_train
    puts 'Type train number'
    train_number = gets.chomp
    puts 'Which type of the train do you want to create. \'P\' for passenger and \'C\' for cargo'
    choice = gets.chomp.upcase
    create_train_by_type(choice, train_number)
  end

  def create_train_by_type(type, train_number)
    case type
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

    stations = ask_stations
    return if stations.nil?

    route = Route.new(stations[0], stations[1])
    puts "#{route} was created" if @routes << route
    additional_options(route)
  end

  def ask_stations
    puts 'Type title of starting station'
    first_station_title = gets.chomp
    puts 'Type title of ending station'
    last_station_title = gets.chomp

    first_station = find_station_by_title(first_station_title)
    last_station = find_station_by_title(last_station_title)
    if first_station && last_station
      [first_station, last_station]
    else
      puts 'Error. One or two such stations do not exist'
    end
  end

  def additional_options(route)
    loop do
      puts 'If you want add station to the route press \'A\', if you want to delete station press \'D\','\
           ' if you want to exit press any other button'
      choice = gets.chomp.upcase
      case choice
      when 'A'
        add_station_to_route(route)
      when 'D'
        delete_station_from_route(route)
      else
        break
      end
    end
  end

  def add_station_to_route(route)
    puts 'Type title of the station'
    station_title = gets.chomp
    station = find_station_by_title(station_title)
    if station
      puts "#{station_title} was successfully added to the #{route}" if route.add_intermediate_station(station)
    else
      puts "#{station_title} not found"
    end
  end

  def delete_station_from_route(route)
    puts 'Type title of the station'
    station_title = gets.chomp
    station = find_station_by_title(station_title)
    if route.stations.include?(station)
      puts "#{station_title} was successfully deleted from the #{route}" if route.stations.delete(station)
    else
      puts "#{station_title} not found in the route"
    end
  end

  def add_route_to_train
    return unless routes?

    train = train_exist?
    return unless train

    get_route(train)
  end

  def routes?
    puts 'Error. There are not any routes' unless @routes.any?
    @routes.any?
  end

  def get_route(train)
    puts 'Type number of the route that you want to add to the train'
    # increase index to make more habitual to people format
    @routes.each.with_index { |route, index| puts "№#{index + 1}. route with stations #{route.stations.map(&:title)}" }
    number = gets.chomp.to_i - 1
    route = @routes[number]
    if route
      puts 'Train successfully get route' if train.get_route(route)
    else
      puts 'Error. You type wrong number of the route'
    end
  end

  def wagon_menu_options
    puts 'What do you want to do?'
    [
      '- Press 1 to add wagon to the train',
      '- Press 2 to remove wagon from the train',
      '- Press 3 to add passengers or cargo to the wagon',
      '- Press 4 to see all train wagons',
      '- Press 0 to exit from the program'
    ].each { |option| puts option }
  end

  def wagon_menu
    wagon_menu_options
    choice = gets.chomp.to_i
    case choice
    when 1
      add_wagon_to_train
    when 2
      remove_wagon_from_train
    when 3
      take_space
    when 4
      show_wagons
    end
  end

  def add_wagon_to_train
    train = train_exist?
    return unless train

    answers = type_and_volume_of_train
    case answers[0]
    when 'P'
      wagon = PassengerWagon.new(answers[1])
    when 'C'
      wagon = CargoWagon.new(answers[1])
    else
      puts 'Error. You type wrong type'
      return
    end

    train_added?(train, wagon)
  end

  def type_and_volume_of_train
    puts 'Which type of the wagon do you want to add? \'P\' for passenger and \'C\' for cargo'
    type = gets.chomp.upcase
    puts 'How many seats/tons are available in the wagon?'
    volume = gets.chomp.to_i
    [type, volume]
  end

  def train_added?(train, wagon)
    if train.add_wagon(wagon)
      puts 'Train and wagon are successfully connected'
    else
      puts 'Error. Incompatible types of train and wagon'
    end
  end

  def remove_wagon_from_train
    train = train_exist?
    return unless train

    return unless wagons?(train)

    puts 'Type number of the wagon that you want remove from the train'
    display_train_wagons(train)
    number = gets.chomp.to_i - 1
    wagon = train.wagons[number]
    if wagon
      puts 'Wagon was successfully removed' if train.remove_wagon(wagon)
    else
      puts 'Error. You type wrong number of the wagon'
    end
  end

  def take_space
    train = train_exist?
    return unless train

    return unless wagons?(train)

    puts 'Write the number of the wagon to which you want to add passengers or cargo'
    display_train_wagons(train)
    number = gets.chomp.to_i - 1
    wagon = train.wagons[number]
    if wagon.type == :passenger
      puts 'Passenger successfully added' if wagon.take_space
    else
      puts 'How much cargo do you want to add?'
      weight = gets.chomp.to_i
      puts 'Cargo successfully added' if wagon.take_space(weight)
    end
  end

  def show_wagons
    train = train_exist?
    return unless train

    return unless wagons?(train)

    display_train_wagons(train)
  end

  def move_train
    train = train_exist?
    return unless train

    routes_on_train?(train)

    puts 'In which side do you want to move the train? \'F\' - forward, \'B\' - back.'
    side = gets.chomp.upcase
    case side
    when 'F'
      puts train.move_to_next_station ? 'Choo-choo, moved to the next station' : 'Error. Something went wrong'
    when 'B'
      puts train.move_to_previous_station ? 'Choo-choo, moved to the previous station' : 'Error. Something went wrong'
    else
      puts 'Error. You type wrong option'
    end
  end

  def routes_on_train?(train)
    puts 'Train don\'t have any routes, first add it.' if train.route.nil?
    train.route
  end

  def show_stations
    return unless stations?

    puts 'Trains on which station do you want to see?'
    @stations.each.with_index { |station, index| puts "№#{index + 1} Station #{station.title}" }
    number = gets.chomp.to_i - 1
    station = @stations[number]
    if station
      unless station.trains.any?
        puts 'There are not any trains on the station'
        return
      end
      message_format = ->(train) { puts "Train: #{train.train_number}, type: #{train.type}, wagons: #{train.wagons}" }
      station.each_train(&message_format)
    else
      puts 'Error. You type wrong number of the station'
    end
  end

  def stations?
    puts 'There are no any stations' unless @stations.any?
    @stations.any?
  end

  def train_exist?
    puts 'Type train number'
    train_number = gets.chomp
    train = Train.find(train_number)
    puts 'Error. This train is not exist' unless train
    train
  end

  def wagons?(train)
    puts 'Train doesn\'t have any wagons' unless train.wagons.any?
    train.wagons.any?
  end

  def display_train_wagons(train)
    # increase index to make more habitual to people format
    message_format =
      if train.type == :passenger
        lambda { |wagon, index|
          puts "№#{index + 1} Wagon, type: #{wagon.type},"\
               " available seats: #{wagon.free_space}, occupied seats: #{wagon.occupied_space}"
        }
      else
        lambda { |wagon, index|
          puts "№#{index + 1} Wagon, type: #{wagon.type},"\
               " available volume: #{wagon.free_space}, occupied volume: #{wagon.occupied_space}"
        }
      end
    train.each_wagon(&message_format)
  end
end
