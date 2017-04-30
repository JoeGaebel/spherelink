# encoding: utf-8

class SoundUploader < BaseUploader
  def extension_whitelist
    %w(mp3)
  end
end
