class Clue < ActiveRecord::Base
  belongs_to :game
  belongs_to :game_history
  validates :hint , :question , :answer , presence: true
  has_one :coordinate

  def discover(user)
    self.discovered = true
    self.game_history = GameHistory.where(game_id: game.id , user_id: user.id).take
    save
  end
end
