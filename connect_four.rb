require_relative "player"
require_relative "connect_four/board"

require "forwardable"

# Connect Four game
class ConnectFour
  extend Forwardable
  def_delegators :board, :row_count, :col_count
  attr_reader :players, :board

  WIN_THRESHOLD = 4

  def initialize(players:, dimensions: [1, 2])
    @players = players
    @board = ConnectFour::Board.new(dimensions[0], dimensions[1])

    @player_cycle = players.cycle

    raise ArgumentError, "Must have at least two players" if @players.length < 2
    raise ArgumentError, "Players can't have the same token" if @players.map(&:token).uniq.length != @players.length
  end

  def move(player, column)
    @board.add_to_column(column, token: player.token)
    @player_cycle.next # Advance the player cycle
  end

  def current_player
    @player_cycle.peek
  end

  STATUSES = [:win, :tie, :ongoing].freeze

  def status
    if winner
      :win
    elsif @board.full?
      :tie
    else
      :ongoing
    end
  end

  STATUSES.each do |status|
    define_method("#{status}?") { self.status == status }
  end

  def winner
    line_permutations.each do |line|
      line.each_cons(WIN_THRESHOLD) do |tokens|
        next unless tokens.uniq.length == 1 # all same
        next if tokens.first.nil? # not nil

        return Player.from_token(tokens.first)
      end
    end

    nil
  end

  private

  def line_permutations
    lines = []

    # Rows (horizontal)
    lines.concat @board.matrix

    # Columns (vertical)
    @board.col_count.times do |col_num|
      lines << @board.col(col_num)
    end

    # Diagonals
    # (@board.col_count + @board.row_count - 2).times do |k|
    #   line = []
    #   (k + 1).times.each do |j|
    #     i = k - j
    #     next if i >= @board.row_count || j >= @board.col_count
    #
    #     line << (@board.cell(i, j) || [i, j].inspect)
    #   end
    #   lines << line
    # end

    lines
  end
end
