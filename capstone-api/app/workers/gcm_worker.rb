class GcmWorker
  include Sidekiq::Worker

  def perform(game_id)
    gcm = GCM.new("AIzaSyDgEwlJvSX1Jew18m90u4K-ijIoXQHmkss")
    options = {data: data[:message]}
    gcm.send(data[:tokens], options)
  end
end
