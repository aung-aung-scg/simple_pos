# === Admin/User Accounts ===
User.find_or_create_by!(email: "admin@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  user.role = "admin"
  user.admin = true
  user.name = "Admin User"
  user.phone = "1234567890"
  user.address = "575B Pyay Road, Yangon, Myanmar"
end

User.find_or_create_by!(email: "user@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  user.role = "user"
  user.admin = false
  user.name = "Test User"
  user.phone = "1234567890"
  user.address = "575B Pyay Road, Yangon, Myanmar"
end
