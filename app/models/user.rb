class User < ActiveRecord::Base
  
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  after_create :add_role

  def vaceditor?
    self.role == 'vaceditor' ? true : false
  end


  private

  def add_role
    self.role = 'user'
    self.save!
  end
end
