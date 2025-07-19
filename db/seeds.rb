# === Admin/User Accounts ===
User.find_or_create_by!(email: "admin@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  user.role = "admin"
  user.admin = true
  user.name = "Admin User"
end

User.find_or_create_by!(email: "user@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  user.role = "user"
  user.admin = false
  user.name = "Test User"
end

# === Main Clothing Categories ===
men     = Category.find_or_create_by!(name: "Men", parent_id: nil)
women   = Category.find_or_create_by!(name: "Women", parent_id: nil)
kids    = Category.find_or_create_by!(name: "Kids", parent_id: nil)

# === Subcategories for Men ===
["Shirts", "T-Shirts", "Jeans", "Jackets", "Shoes", "Accessories"].each do |name|
  Category.find_or_create_by!(name: name, parent: men)
end

# === Subcategories for Women ===
["Dresses", "Tops", "Skirts", "Heels", "Handbags", "Accessories"].each do |name|
  Category.find_or_create_by!(name: name, parent: women)
end

# === Subcategories for Kids ===
["Shirts", "Shorts", "School Shoes", "Toys", "Jackets"].each do |name|
  Category.find_or_create_by!(name: name, parent: kids)
end

# === Sample Products (Development Only) ===
# These products can be manually linked to categories later
Product.find_or_create_by!(name: "White T-Shirt") do |p|
  p.price = 35000
  p.stock = 50
  p.gender = "men"
  p.description = "Soft cotton white T-shirt."
end

Product.find_or_create_by!(name: "Blue Denim Jeans") do |p|
  p.price = 50000
  p.stock = 30
  p.gender = "men"
  p.description = "Slim-fit blue jeans."
end

Product.find_or_create_by!(name: "Red Dress") do |p|
  p.price = 40000
  p.stock = 20
  p.gender = "women"
  p.description = "Elegant evening dress."
end
