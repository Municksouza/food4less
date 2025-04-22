require 'ostruct'

module SolidCable
  def self.config
    @config ||= OpenStruct.new
  end
end

SolidCable.config.unique_index_check = false
