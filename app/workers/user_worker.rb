class UserWorker
  include Sidekiq::Worker

  def perform(*args)
    Mirroring::User::Create.new(*args).mirror_and_save_user
  end
end
