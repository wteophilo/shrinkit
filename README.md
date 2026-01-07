# Shrinkit — Simple URL shortener 🔗

Shrinkit is a lightweight Ruby on Rails application that provides a minimal, secure URL shortening service. It stores long URLs and generates short, non-sequential short codes using Hashids (wrapped by `EncodedService`).

---

## Features ✅

- Create shortened URLs from long URLs via a small web UI
- Short codes generated using a secret salt with the `hashids` gem (configurable via env var)
- Validates URLs (protocol and host) with a custom `UrlValidator`
- Redirects short codes to the original long URL (with `allow_other_host`)
- Simple test suite using RSpec

---

## Quick Start 🔧

Requirements
- Ruby 3.4.6 (see `.ruby-version`)
- Bundler
- SQLite (default development DB)
- Node/npm is not required (this app uses importmaps)

Local setup

```bash
# Install gems
bundle install

# Create and migrate the database
bin/rails db:create db:migrate

# Run the test suite
bundle exec rspec

# Start the dev server
bin/rails server
# then visit http://localhost:3000
```

Docker (production-style image)

```bash
# Build (production Dockerfile)
docker build -t shrinkit .

# Run (ensure you provide RAILS_MASTER_KEY in production)
docker run -d -p 80:80 -e RAILS_MASTER_KEY=<your_master_key> --name shrinkit shrinkit
```

---

## Configuration ⚙️

Important environment variables
- `MY_SECRET_KEY` — Salt used by `EncodedService` (Hashids). Set this in production (do NOT use the dev fallback).
- `ALPHABET` — Optional custom alphabet for generated short codes.
- `RAILS_MASTER_KEY` — Required for running in production if credentials are encrypted.

EncodedService (short-code generation)
- Implemented in `app/services/encoded_service.rb` using the `hashids` gem.
- By default the service will use `MY_SECRET_KEY` and a sensible alphabet; change via env vars if needed.

---

## Usage 📋

- Visit the root (`/`) to submit a long URL.
- After creating a URL you'll be redirected to a show page that displays the short URL.
- Short URL format: `http://<host>/<short_code>` which internally maps to `/urls/redirect/:short_code` and performs a redirect to the original `long_url`.

API example (simple):

```bash
curl -X POST -d "url[long_url]=https://example.com" http://localhost:3000/urls
```

---

## Testing 🧪

Run RSpec:

```bash
bundle exec rspec
```

The repository includes specs for models, controllers, and services.

---

## Development notes & Internals 🔍

- Rails: `~> 8.1.1`
- Database: `sqlite3` for development/test
- Gems: `hashids`, `base62` (helper utilities), `brakeman` and `rubocop` in dev/test
- Model: `Url` with `long_url:string` and `short_code:string` (see `db/migrate/*_create_urls.rb`)
- Validation: `app/validators/url_validator.rb` ensures a proper URL format and protocol

