require 'csv'

class ReportMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def balance_report(email)
    @people = Person.order(:name)
    csv_data = generate_csv(@people)
    attachments['balance_report.csv'] = { mime_type: 'text/csv', content: csv_data }

    mail(to: email, subject: 'Balance Report')
  end

  private

  def generate_csv(people)
    CSV.generate(headers: true) do |csv|
      csv << ['Name', 'Balance']
      people.each do |person|
        csv << [person.name, person.balance]
      end
    end
  end
end
