require 'spec_helper'

describe Sphere, type: :model do
  it { is_expected.to validate_presence_of :caption }
end
