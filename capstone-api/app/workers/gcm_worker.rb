class GcmWorker
  include Sidekiq::Worker

  def perform(game_id)
    game = Game.includes(:clues, :users).find(game_id)
    gcm = GCM.new(Rails.configuration.x.GCM_KEY)
    options = {data: {clues: game.clues.where(discovered: false)}}
    puts gcm.send(game.tokens, options)
  end
end
