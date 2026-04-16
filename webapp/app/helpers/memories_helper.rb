module MemoriesHelper
  def is_owner?(memory)
    memory.user_id == current_user.id
  end
end
