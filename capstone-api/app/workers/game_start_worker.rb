class GameStartWorker
  include Sidekiq::Worker

  def perform(game_id)
    game = Game.includes(:users).find(game_id)
    game.update(active: true)
    tokens = []
    game.users.each do |user|
      user.tokens.each { |token| tokens << token.token }
    end
    gcm = GCM.new(Rails.configuration.x.GCM_KEY)
    response = gcm.send(tokens, data: {message: "#{game.name} has started!"})
    puts response
  end
end
