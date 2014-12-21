class WithdrawAddress < Address
  has_many :withdraws
  validates :label, { presence: true, :message => "请给我个标签" }

end
