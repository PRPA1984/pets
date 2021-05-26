class User < ApplicationRecord
  has_many :permissions
  has_many :pets

  validates :name, :login, :password, presence: true

  validates :login, uniqueness: true

  validates :password, length: { minimum: 7 }

  scope :enabled, -> { where(enabled: true) }

  def valid_password?(pass)
    password.present? && password == pass
  end

  def generate_token!
    # Token persistente
    
    # Token con expiracion
    # client_redis.set("session_#{user.id}", token, ex: (60 * 60))
    token = SecureRandom.urlsafe_base64 

    $client_redis.set("session_#{token}", id)

    token
  end

  def remove_token(token)
    $client_redis.del("session_#{token}")
  end

  def add_role(role)
    role = Role.find_by(name: role) if role.instance_of?(String)

    raise "No existe lo que pasaste" if role.blank?

    Permission.create!(user: self, role: role)
  end

  def remove_role(role)
    role = Role.find_by(name: role) if role.instance_of?(String)

    raise "No existe lo que pasaste" if role.blank?

    permissions.where(role_id: role.id).each(&:destroy)
  end

  def admin?
    role_names.include?('admin')
  end

  def role_names
    permissions.includes(:role).pluck("roles.name")
  end

  def json
    { id: id, name: name, login: login, enabled: enabled, permissions: role_names }
  end

  def self.find_by_token(htoken)
    id = $client_redis.get("session_#{htoken}")

    User.find_by(id: id)
  end
end
