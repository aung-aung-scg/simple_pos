# Clover Queen Clothing

A modern admin dashboard for managing e-commerce operations, built with Ruby on Rails, Bootstrap 5, and Hotwire.

## ✨ Features

- **User Management**
  - Role-based access control (Admin, User)
  - User authentication with Devise
  - Activity tracking

- **Product Catalog**
  - Product variants and options
  - Category management with nested categories
  - Image uploads with Active Storage (supports multiple images)
  - Inventory tracking

- **Order Processing**
  - Order lifecycle management
  - Status tracking
  - Customer communication

- **Dashboard Analytics**
  - Sales reports
  - Inventory alerts
  - Customer insights

- **Technical Features**
  - Responsive design with mobile support
  - Turbo Streams for real-time updates
  - Sorting, filtering, and pagination

## ⚙️ System Requirements

- Ruby 3.3.0
- Rails 7.1.3
- PostgreSQL 14+
- Node.js 16+
- Yarn 1.22+
- ImageMagick or libvips for image processing


## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/simple_pos.git
   cd simple_pos

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

        Email: admin@gmail.com

        Password: password
