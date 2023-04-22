# Bolt-up and deploy a Lightning Node to Lagoon

## Run locally
 - `cp .env.local.example .env.local` and modify the variables if needed
 - `docker-compose up`

## BoltUp Base (boltupbase/)
 - Builds a base container that TOR, LND, and others can depend on
 - Copies ideas from Lagoon node and node-cli base images
 - lagoon.type: none

## TOR (tor/)
 - Basic ideas from https://github.com/Schnitzel/donations.schnitzel.world-proxy
 - Starts tor as a CMD in the Dockerfile
 - lagoon.type: basic-persistent

## LND (lnd/)
 - Basics from https://github.com/alexbosworth/run-lnd#install-lnd
 - Downloads and installs the binary release from github
 - lagoon.type: basic-persistent


