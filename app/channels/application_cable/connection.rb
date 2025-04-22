module ApplicationCable
  class Connection < ActionCable::Connection::Base
    def connect
      # No verification needed if you only receive orders
    end
  end
end
