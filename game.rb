# frozen_string_literal: true

require_relative "connect_four"

require "debug"

class Game
  attr_reader :status

  def initialize
    @connect_four = nil
  end

  def start
    puts "Welcome to Connect Four!"

    setup
    while @connect_four.ongoing? do
      play_round
    end
    game_over

  rescue Interrupt
    puts "\n\nGoodbye!"
  end

  private

  def setup
    players = [
      setup_player(1, "X"),
      setup_player(2, "O")
    ]

    @connect_four = ConnectFour.new(players: players)
  end

  def play_round
    player = @connect_four.current_player
    puts "\n#{player.name} (#{player.token}), it's your turn."

    print_board

    begin
      print "Choose a column: "
      input = gets.chomp.match(/\d+/)&.[](0)
      raise ArgumentError, "Please enter a column number" unless input

      col_num = input.to_i - 1
      @connect_four.move(player, col_num)
    rescue ArgumentError => e
      puts e.message
      retry
    end
  end

  def game_over
    print "\n\n"
    print_board

    puts "\nGame over! "
    case @connect_four.status
    when :tie
      puts "It's a tie!"
    when :win
      puts "Congratulations, #{@connect_four.winner.name}! You won!"
    end
  end

  def print_board
    print "    "
    hr = "----"
    @connect_four.board.col_count.times.each do |col_num|
      print col_num + 1
      print " "
      hr += "--"
    end
    puts
    puts hr

    @connect_four.board.row_count.times do |row_num|
      print "#{row_num + 1} | "
      @connect_four.board.row(row_num).each do |cell|
        print (cell || " ") + " "
      end
      puts
    end
  end

  def setup_player(number, token)
    print "What is player #{number}'s name? "
    name = gets.chomp
    player = Player.new(name, token)

    puts "Great! #{player.name} will be #{player.token}\n\n"
    player
  rescue ArgumentError => e
    puts e.message
    retry
  end

end

game = Game.new
game.start
