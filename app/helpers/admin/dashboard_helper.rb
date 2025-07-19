module Admin::DashboardHelper
  def order_status_badge_color(status)
    case status
    when 'completed' then 'success'
    when 'pending' then 'warning'
    when 'cancelled' then 'danger'
    when 'shipped' then 'info'
    else 'secondary'
    end
  end

  def order_status_icon(status)
    case status
    when 'completed' then 'check-circle'
    when 'pending' then 'hourglass-split'
    when 'cancelled' then 'x-circle'
    when 'shipped' then 'truck'
    else 'question-circle'
    end
  end
end
