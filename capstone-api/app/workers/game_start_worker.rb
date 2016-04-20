class GameStartWorker
  include Sidekiq::Worker

  def perform(game_id)
    Game.find(game_id).update(active: true)
  end
end
