# Demo Application

This is a simple Ruby on Rails demo application which uses a postgres database
for persistence and a background job for sending emails.

## Installation

    bundle install
    bin/rake db:migrate

## Running the server

    bin/rails server

## Running the background worker

    bin/rake jobs:work
