class User < ApplicationRecord
  extend Enumerize
  include Humanizer

  has_paper_trail only: [:name, :about_de, :about_en, :role]

  extend Mobility
  translates :about

  attr_accessor :bypass_humanizer
  require_human_on :create, unless: :bypass_humanizer

  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, authentication_keys: [:email]

  mount_base64_uploader :avatar, AvatarUploader

  has_many :created_pages,  foreign_key: :creator_id, class_name: 'Page'
  has_many :created_images, foreign_key: :creator_id, class_name: 'Image'
  has_many :created_bookings, foreign_key: :organisator_id, class_name: 'Booking'

  has_and_belongs_to_many :bookings

  enumerize :role, in: [:user, :editor, :admin], default: :user

  validates :avatar, file_size: {maximum: (Rails.env.test? ? 15 : 500).kilobytes.to_i} # TODO: It would be nice to stub the maximum within the spec itself. See https://gist.github.com/chrisbloom7/1009861#comment-1220820
end
