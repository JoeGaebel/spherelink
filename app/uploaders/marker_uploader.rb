# encoding: utf-8

class MarkerUploader < BaseUploader
  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
