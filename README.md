# Docker Compose Redirect Everything

This is the docker-compose configuration that I use on my DigitalOcean droplet to redirect my secondary domains to my primary one using nginx and [Traefik](https://traefik.io/). It redirects both the root domain and all subdomains to the target domain:

| From | To |
|------|----|
| example.test | example2.test |
| example.test/path/to/index.html | example2.test/path/to/index.html |
| sub.example.test | sub.example2.test |
| sub.example.test/path/to/index.html | sub.example2.test/path/to/index.html
| sub.sub.example.test | sub.sub.example2.test |
| sub.sub.example.test/path/to/index.html | sub.sub.example2.test/path/to/index.html

## Usage

1. Clone this repository.
2. Copy `.env.example` to `.env` and modify the variables.
3. Run `./start.sh`.

To stop the services, run `docker-compose down`.
