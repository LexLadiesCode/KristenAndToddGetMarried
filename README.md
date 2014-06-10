# Kristen and Todd Get Married

## How to Run the App

You need to know Kristen and Todd's Wanderable.com registry URL, not included
in this repository for privacy purposes.

1. `bundle`
1. `bundle exec rake db:migrate`
1. `WANDERABLE_URL="https://wanderable.com/hm/CHANGE-ME" rails s`

## How to Run Tests

1. `bundle`
1. `RAILS_ENV=test bundle exec rake db:migrate`
1. `RAILS_ENV=test bundle exec rspec`
