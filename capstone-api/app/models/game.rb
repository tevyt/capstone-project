class Game < ActiveRecord::Base
  include DistanceManager
  validates :name , presence: true
  validates :radius , numericality: {greater_than: 0 , less_than: 6_371_000_000} #Radius can't be bigger than the radius of the earth!
  validates :start_time, presence: true
  has_many :game_histories
  has_many :users, through: :game_histories
  has_many :clues , dependent: :destroy
  belongs_to :user
  alias_attribute :creator, :user
  validate :start_date_must_be_in_the_future


  def start()
    return false if active?
    update(active: true)
  end

  def terminate()
    return false unless active?
    update(end_time: DateTime.now, active: false)
  end

  def add_clue(new_clue)
    clues.each { |clue| return false if intersect?(new_clue.coordinate , clue.coordinate) }
    clues << new_clue
  end

  private 
  def intersect?(coordinate1 , coordinate2)
    meter_distance(coordinate1 , coordinate2) <=  2 * radius
  end

  protected
  def start_date_must_be_in_the_future
    errors.add(:start_time, 'Start Time must be in the future') if start_time.present? and start_time < DateTime.now
  end

end

