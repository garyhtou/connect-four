# frozen_string_literal: true

class ConnectFour
  class Board
    attr_reader :row_count, :col_count, :matrix

    def initialize(row_count, col_count)
      @row_count = row_count
      @col_count = col_count

      # @board[row][col]
      @matrix = Array.new(@row_count) { Array.new(@col_count) }
    end

    def cell(row, col)
      @matrix[row][col]
    end

    # Cells for a single column
    def col(col)
      @matrix.map { |row| row[col] }
    end

    # Cells for a single row
    def row(row)
      @matrix[row]
    end

    # Returns the row # of the added token
    def add_to_column(col_num, token:)
      raise ArgumentError, "Invalid move. Column #{col_num + 1} does not exist" if col_num >= @col_count || col_num < 0
      raise ArgumentError, "Invalid move. Column #{col_num + 1} is full" if @matrix[0][col_num]

      col(col_num).each.with_index.reverse_each do |cell, i|
        next if cell

        @matrix[i][col_num] = token
        return i
      end
    end

    def full?
      @matrix.all? { |row| row.all? }
    end

    def token_count
      @matrix.flatten.compact.length
    end
  end
end
