module Admin::UsersHelper
  def role_badge_color(role)
    case role
    when 'admin' then 'primary'
    when 'user' then 'success'
    else 'secondary'
    end
  end
end
