# Snapcast with Go Librespot setup

This project combines [Snapcast](https://github.com/snapcast/snapcast) with [Go Librespot](https://github.com/devgianlu/go-librespot) and creating a normal 16 bit device and a HQ 32 bit device. This project only provides the server. Use a snapcast client with the project.

## Quick Start (Docker)

1. (Optional) Create a copy of .env.example and name it .env. You can change the variables in here as your liking.
2. Run `docker compose up --build` in the project root to start the server.
