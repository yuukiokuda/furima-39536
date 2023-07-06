class Address < ApplicationRecord
  belongs_to :order

    # # 数字3桁、ハイフン、数字4桁の並びのみ許可する
    # validates :postal_code, presence: true, format: {with: /\A[0-9]{3}-[0-9]{4}\z/, message: "is invalid. Include hyphen(-)"}
    # # 0以外の整数を許可する
    # validates :prefecture, numericality: {other_than: 0, message: "can't be blank"}
    # # 10,11桁の半角数字のみを許可する
    # validates :phone_number, format: { with: /\A\d{10,11}\z/, message: "Invalid. Please enter only digits in half-width characters." }

end
