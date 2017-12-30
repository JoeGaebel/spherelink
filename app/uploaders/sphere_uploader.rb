class SphereUploader < BaseUploader
  MAX_WIDTH = 8000
  after :store, :update_processing_status

  process resize_to_limit: [MAX_WIDTH, -1]

  version :thumb do
    process resize_to_fill: [80, 80]
  end

  private

  def update_processing_status(_)
    new_bits = model.processing_bits - 1

    if new_bits == -1
      raise StandardError("Negative Bits after processing!")
    end

    model.update_attribute(:processing_bits, new_bits)
  end
end
