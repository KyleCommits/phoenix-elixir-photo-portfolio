# Photo Portfolio

A Phoenix-based photo portfolio application with EXIF data extraction and responsive gallery view.

## Project Statistics

### Technology Stack
- Elixir 1.12+
- Phoenix Framework 1.7.10
- PostgreSQL Database
- TailwindCSS for styling
- Phoenix LiveView 0.20.1

### Key Features
- Responsive masonry-style photo gallery
- EXIF data extraction from uploaded images
- Image upload with preview
- Photo metadata display
- GPS coordinate tracking (if available in EXIF)
- Responsive design for mobile and desktop

### Project Structure
```
photo_portfolio/
├── lib/                      # Main application code
│   ├── photo_portfolio/      # Business logic
│   └── photo_portfolio_web/  # Web interface
├── priv/                     # Private application files
│   ├── repo/                 # Database migrations
│   └── static/               # Static assets
├── assets/                   # Frontend assets
│   ├── css/                  # Stylesheets
│   └── js/                   # JavaScript files
└── test/                     # Test files
```

### Dependencies
- `:phoenix` - Web framework
- `:phoenix_ecto` - Database integration
- `:phoenix_live_view` - Real-time UI
- `:exexif` - EXIF data extraction
- `:tailwind` - CSS framework

## Setup

1. Clone the repository
```bash
git clone https://github.com/YOUR_USERNAME/photo_portfolio.git
cd photo_portfolio
```

2. Install dependencies
```bash
mix deps.get
cd assets && npm install && cd ..
```

3. Create and migrate database
```bash
mix ecto.setup
```

4. Start Phoenix server
```bash
mix phx.server
```

Visit [`localhost:4000`](http://localhost:4000) from your browser.

## Development

### Configuration
- Copy `config/dev.sample.exs` to `config/dev.secret.exs`
- Update database credentials in `config/dev.secret.exs`

### File Upload Limits
- Maximum file size: 10MB
- Supported formats: JPG, PNG, GIF
- EXIF data extraction supported for JPG files

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.