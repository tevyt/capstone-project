class Game < ActiveRecord::Base
  include DistanceManager
  validates :name , presence: true
  validates :radius , numericality: {greater_than: 0 , less_than: 6_371_000_000} #Radius can't be bigger than the radius of the earth!
  has_many :game_histories
  has_many :users, through: :game_histories
  has_many :clues , dependent: :destroy


  def start()
    return false if active?
    update(start_time:  DateTime.now , active: true)
  end

  def terminate()
    return false unless active?
    update(end_time: DateTime.now, active: false)
  end

  def add_clues()
  end

  private 
  def intersect?(coordinate1 , coordinate2)
    meter_distance(coordinate1 , coordinate2) <=  2 * @radius	
  end

end

