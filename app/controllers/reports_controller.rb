class ReportsController < ApplicationController
  def balance
    ReportMailer.balance_report(current_user.email).deliver_later
    redirect_to root_path, notice: 'Será enviado um e-mail em instantes.'
  end
end
