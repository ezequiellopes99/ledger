class Dashboard
  def initialize(user)
    @user = user
  end

  def active_people_pie_chart
    Rails.cache.fetch("#active_people_pie_chart", expires_in: 5.minutes) do
      {
        active: Person.where(active: true).count,
        inactive: Person.where(active: false).count
      }
    end
  end

  def total_debts
    Rails.cache.fetch("#total_debts", expires_in: 5.minutes) do
      active_people_ids = Person.where(active: true).select(:id)
      Debt.where(person_id: active_people_ids).sum(:amount)
    end
  end

  def total_payments
    Rails.cache.fetch("#total_payments", expires_in: 5.minutes) do
      active_people_ids = Person.where(active: true).select(:id)
      Payment.where(person_id: active_people_ids).sum(:amount)
    end
  end

  def balance
    Rails.cache.fetch("#balance", expires_in: 5.minutes) do
      total_payments - total_debts
    end
  end

  def last_debts(limit = 10)
    Rails.cache.fetch("#last_debts", expires_in: 5.minutes) do
      Debt.order(created_at: :desc).limit(limit).map { |debt| [debt.id, debt.amount] }
    end
  end

  def last_payments(limit = 10)
    Rails.cache.fetch("#last_payments", expires_in: 5.minutes) do
      Payment.order(created_at: :desc).limit(limit).map { |payment| [payment.id, payment.amount] }
    end
  end

  def my_people(limit = 10)
    Person.where(user: @user).order(:created_at).limit(limit)
  end

  def top_person
    Rails.cache.fetch("#top_person", expires_in: 5.minutes) do
      Person.order(:balance).last
    end
  end

  def bottom_person
    Rails.cache.fetch("#bottom_person", expires_in: 5.minutes) do
      Person.order(:balance).first
    end
  end
end
