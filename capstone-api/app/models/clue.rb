class Clue < ActiveRecord::Base
  belongs_to :game
  belongs_to :game_history
  validates :hint , :question , :answer , presence: true
  has_one :coordinate

  #Set a clue as discovered, GameHistory exists due to association between Games and Users
  def discover(user)
    update(discovered: true)
    self.game_history = GameHistory.where(game_id: game.id , user_id: user.id).take
    self.game_history.score += 1
    self.game_history.save
    save
  end
end
