require 'spec_helper'

describe Memory, type: :model do
  it { is_expected.to validate_presence_of :name }
end
