class User < ApplicationRecord
  has_many :permissions

  validates :name,
            :login,
            :password,
            presence: true

  validates :login, uniqueness: true

  validates :password, length: { minimum: 6 }

  before_create :set_token

  def set_token
    self.token = SecureRandom.urlsafe_base64
  end

  def add_roles(roles)
    roles = Role.where(name: [roles].flatten.map(&:to_s))

    roles.each do |role|
      next if permissions.find_by(role_id: role.id).present?

      permissions.create!(role: role)
    end
  end

  def remove_roles(role)
    roles = Role.where(name: [roles].flatten)

    roles.each do |role|
      next unless permissions.find_by(role_id: role.id).present?

      permissions.find_by(role_id: role.id).destroy
    end
  end

  def role?(role)
    role = Role.find_by(name: role)

    permissions.find_by(role_id: role.id).present?
  end

  def admin?
    role = Role.find_by(name: 'admin')

    permissions.find_by(role_id: role.id).present?
  end

  def change_password!(new_password)
    self.password = new_password
    valid? ? save! : errors
  end
end
