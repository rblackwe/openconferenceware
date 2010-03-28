class AddSaltToUsers < ActiveRecord::Migration
  def self.up
    User.all.each do|user|
      unless user.salt 
        user.add_salt
        user.save!
        print '.'
      end
    end
    puts "\nDone"
  end

  def self.down
  end
end
