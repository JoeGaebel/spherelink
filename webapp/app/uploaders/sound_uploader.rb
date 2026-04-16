# encoding: utf-8

class SoundUploader < BaseUploader
  def extension_white_list
    %w(mp3)
  end
end
