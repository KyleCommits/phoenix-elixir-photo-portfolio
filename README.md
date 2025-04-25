# Photo Portfolio

A Phoenix-based photo portfolio application with EXIF data extraction and gallery view.

## Setup

1. Clone the repository
2. Copy `config/dev.sample.exs` to `config/dev.secret.exs` and update with your credentials
3. Install dependencies:
   ```bash
   mix deps.get
   cd assets && npm install
   ```
4. Create and migrate database:
   ```bash
   mix ecto.setup
   ```
5. Start Phoenix server:
   ```bash
   mix phx.server
   ```

Now visit [`localhost:4000`](http://localhost:4000) from your browser.

## Features

- Photo upload with EXIF data extraction
- Responsive gallery view
- Photo details display
- Image management