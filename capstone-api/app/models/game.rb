class Game < ActiveRecord::Base
  include DistanceManager
  validates :name , presence: true
  validates :radius , numericality: {greater_than: 0 , less_than: 6_371_000_000} #Radius can't be bigger than the radius of the earth!
  validates :start_time, presence: true
  validates :end_time, presence: true
  has_many :game_histories
  has_many :users, through: :game_histories
  has_many :clues , dependent: :destroy
  belongs_to :user
  alias_attribute :creator, :user
  validate :start_date_must_be_in_the_future, on: :create
  validate :end_date_must_be_in_the_future, on: :create
  validate :end_date_after_start_date, on: :create
  after_create :start
  alias_method :players, :users

  def terminate
    return false unless active?
    update(end_time: DateTime.now, active: false)
  end

  def add_clue(new_clue)
    clues.each { |clue| return false if intersect?(new_clue.coordinate , clue.coordinate) }
    clues << new_clue
  end


  def to_json(options)
    if options
      super(options)
    else
      super(except: :auth_token)
    end
  end

  def score_board
    @score_board = GameHistory.where(game_id: self.id).order(score: :desc)
    @score_board.each_index { |index| @score_board[index].rank = index + 1 }
  end

  def tokens 
    token_array = []
    players.each do |player|
      player.tokens.each { |token| token_array << token.token }
    end
    token_array
  end

  private
  def intersect?(coordinate1 , coordinate2)
    meter_distance(coordinate1 , coordinate2) <=  2 * radius
  end

  protected
  def start_date_must_be_in_the_future
    errors.add(:start_time, 'Start Time must be in the future') if start_time.present? and start_time < DateTime.now
  end
  
  def end_date_must_be_in_the_future
    errors.add(:end_time, 'End Time must be in the future') if end_time.present? and end_time < DateTime.now
  end
  
  def end_date_after_start_date
    errors.add(:start_time, 'Start Time must be before End Time') if self[:end_time].present? and start_time.present? and start_time > self[:end_time]
    errors.add(:end_time, 'End Time must be after Start Time') if end_time.present? and self[:start_time].present? and end_time < self[:start_time]
  end
  
  def start
    GameStartWorker.perform_at(start_time, id)
  end
end
