class UserWorker
  include Sidekiq::Worker

  def perform(*args)
    Mirroring::User::Create.new(*args)
  end
end
