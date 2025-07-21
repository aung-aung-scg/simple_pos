# Clover Queen Clothing

A modern admin dashboard for managing e-commerce operations, built with Ruby on Rails, Bootstrap 5, and Hotwire.

## Features

- User management with role-based access control
- Product catalog with variants
- Order processing system
- Category management
- Responsive design with mobile support
- Image uploads with Active Storage
- Sorting and pagination

## Requirements

- Ruby 3.3.0
- Rails 7.1.3
- PostgreSQL 14+
- Node.js 16+
- Yarn 1.22+

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/clover-queen-admin.git
   cd clover-queen-admin

2. Install dependencies:
    bundle install
    yarn install

3. Set up database:
    rails db:create
    rails db:migrate
    rails db:seed
4. Install ImageMagick:
    # Ubuntu/Debian
    sudo apt-get install imagemagick libvips

    # macOS
    brew install imagemagick vips
5. Running the App
    rails s 
    Access at: http://localhost:3000

    Default admin login:

        Email: admin@example.com

        Password: password