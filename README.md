# Kristen and Todd Get Married

## What is this?

A Ruby on Rails app to share wedding information for our friends Kristen and Todd! We wrote a Rails app instead of, say, a simple HTML page because we wanted to display cool data from their [Wanderable](https://wanderable.com) honeymoon registry. Wanderable at the time did not have an API, so this Rails app uses [Mechanize](https://github.com/sparklemotion/mechanize) to scrape data directly off the Wanderable registry web page.

## How to Run the App

You need to know Kristen and Todd's Wanderable.com registry URL, not included
in this repository for privacy purposes.

1. `bundle`
1. `bundle exec rake db:migrate`
1. `cp dotenv.sample .env`
1. Edit `.env` and update the Wanderable registry URL.
1. `rails s`

## How to Run Tests

1. `bundle`
1. `RAILS_ENV=test bundle exec rake db:migrate`
1. `RAILS_ENV=test bundle exec rspec`

## Screenshot

![](http://github.com/LexLadiesCode/KristenAndToddGetMarried/raw/master/screenshot.png)
