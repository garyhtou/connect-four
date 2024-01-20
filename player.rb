# frozen_string_literal: true

class Player
  attr_reader :name, :token
  @@players = []

  def initialize(name, token)
    @name = name
    @token = token

    raise ArgumentError, "Token must be a single character" if @token.length != 1
    raise ArgumentError, "Token must be unique" if @@players.map(&:token).include?(@token)
    raise ArgumentError, "Name must be unique" if @@players.map(&:name).include?(@name)

    @@players << self
  end

  def self.from_token(token)
    @@players.find { |player| player.token == token }
  end
end
