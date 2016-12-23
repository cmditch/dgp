class Transaction < ActiveRecord::Base

  def self.list
    all.map(&:txid)
  end

end
