class ClearRememberTokensForUsers < ActiveRecord::Migration
  def self.up
    User.update_all('remember_token = NULL, remember_token_expires_at = NULL')
  end

  def self.down
  end
end
