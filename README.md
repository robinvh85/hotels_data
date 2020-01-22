# Documentation

## Requirement
- Ruby: 2.6.4
- Database: mysql

## Configuration and setup project
### Change configuration for database

- On file `.env`, change config for your database

```bash
# Database
DATABASE_HOSTNAME=localhost
DATABASE_USERNAME=root
DATABASE_PASSWORD=
```

### Setup application

```bash
bundle install
rails db:create
rails db:migrate
rails db:seed

# Start app
rails s
```

### Setup for task tracking data from supplier

#### Run tracking hotel data by manual

```bash
bundle exec rake tracking_data:track_hotel_data
```

#### Setup schedule for batch
- Modify time for batch schedule at file `config/schedule.rb`

```ruby
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

## Testing

### Run unit tests

```bash
bundle exec rspec spec --format documentation
```

### Test endpoint using curl

```
curl --location --request POST 'http://localhost:3000/api/hotels/search' \
--header 'Content-Type: application/json' \
--data-raw '{
  "destination_id":5432,
  "hotel_ids": ["iJhz", "SjyX"]
}'
```

## Describe more for the way to transform raw data to clean data (class Trackers::HotelTracker)
### Define structure
- Constant `HOTEL_SCHEMA_MAP` : define the structure of clean data with values are appropriate keys of raw data.
- Constant `HOTEL_SCHEMA_RULES` : define rules for transform data for each attribute of data

### Rules
- Rules are actions that handle values that make them better

#### Classify: there are two types of rules
  - `type = Rules::Constants::RULE_TYPE_TRANSFORM` : are rules for transforming data.  For example: trim value, lowercase value, ...
  - `type = Rules::Constants::RULE_TYPE_CHOICE` : are rules compare between current data and new data and do an action. (the action can be choice better data or merge data)

#### Describe rules
- `Rules::LowerCase`: transform by lowercase values
- `Rules::ImageList`: transform image object to valid image object
- `Rules::TrimString`: transform by trim values
- `Rules::BetterLength`: choose better value when length better
- `Rules::MergingList`: merge values if there are some new value

### Steps to process data
- Step 1: get raw data from supplier
- Step 2: sanitize raw data to clean data base on schema at `HOTEL_SCHEMA_MAP`
- Step 3: make data is better by transforming, merging data base on rules that define at `HOTEL_SCHEMA_RULES`

### Advantages of this processing data way
- When having new raw data hotel with another structure, it's easier to handle by modify only the `HOTEL_SCHEMA_MAP`
- When having the idea for which better data is, it's easier to handle by create a `new Rule` and add it to `HOTEL_SCHEMA_RULES`
