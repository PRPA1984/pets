class User < ApplicationRecord
  has_many :permissions

  validates :name, :login, :password, presence: true

  validates :login, uniqueness: true

  validates :password, length: { minimum: 7 }

  scope :enabled, -> { where(enabled: true) }

  before_create :set_token

  def set_token
    self.token = SecureRandom.urlsafe_base64
  end

  def valid_password?(pass)
    password.present? && password == pass
  end

  def remove_token
    update(token: nil)
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
end
