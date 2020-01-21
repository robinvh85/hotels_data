# Documentation

## Requirement
- Ruby: 2.6.x
- Database: mysql

## Setup project
### Modify database config

- At file `.env`, change config for your database

```bash
# Database
DATABASE_HOSTNAME=localhost
DATABASE_USERNAME=root
DATABASE_PASSWORD=
```

### Start app

```bash
bundle install
rails db:create
rails db:migrate
rails db:seed

# Start app
rails s
```

### Run and set schedule for task that tracking data from supplier

#### Run tracking hotel data manual

```bash
bundle exec rake tracking_data:track_hotel_data
```

#### Setup schedule for batch
- Modify time for batch schedule at file `config/schedule.rb`

```
# Default on 00:00 on every sunday
every :sunday, at: '0' do
  rake "tracking_data:track_hotel_data"
end
```

- Apply the schedule to the crontab

```
# For environment `development`
bundle exec whenever --update-crontab --set environment='development'

# For environment `production`
bundle exec whenever --update-crontab

# Check whether the schedule updated to crontab or not
crontab -l
```
