class MemoriesController < ApplicationController
  before_action :set_memory_json, only: [:show]
  def show
  end

  def set_memory_json
    @memory = current_user.memories.find(params[:id])
    @memory_json = @memory.to_builder.target!
  end
end
