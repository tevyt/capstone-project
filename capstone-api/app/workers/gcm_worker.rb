class GcmWorker
  include Sidekiq::Worker

  def perform(data)
    gcm = GCM.new("AIzaSyCy5I7Km3amHc5DZNI64B6nS0r9N_x5I8")
    # gcm = GCM.new("AIzaSyAheFGnDy9PS8ExpshroE8docHIdOd-WgM")
    options = {data: data[:message]}
    response = gcm.send(data[:tokens], options)
  end
end
