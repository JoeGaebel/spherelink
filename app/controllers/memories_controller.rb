class MemoriesController < ApplicationController
  before_action :set_memory_json, only: [:show]
  before_action :ensure_user_logged_in, only: [:index]

  def show
  end

  def index
    @memories = current_user.memories
  end

  def set_memory_json
    @memory = Memory.find(params[:id])
    @memory_json = @memory.to_builder.target!
  end
end
