# cure-mastodon-bots
Precure mastodon bot

[![Dependency Status](https://gemnasium.com/badges/github.com/sue445/cure-mastodon-bots.svg)](https://gemnasium.com/github.com/sue445/cure-mastodon-bots)

[![wercker status](https://app.wercker.com/status/766e3640dce38988ae94a23dd279c71e/m/master "wercker status")](https://app.wercker.com/project/byKey/766e3640dce38988ae94a23dd279c71e)

## Setup
```bash
bundle install
cp .env.example .env
vi .env
```

## Setup Heroku
```bash
heroku config:set MASTODON_URL=https://precure.ml
heroku config:set ACCESS_TOKEN_SAMPLE=xxxxxxxxx
heroku config:set ACCESS_TOKEN_BIRTHDAY=xxxxxxxxx
```

### Scheduler
register rake tasks to [Heroku Scheduler](https://addons.heroku.com/scheduler)

![Heroku Scheduler](img/heroku_scheduler.png)

tasks

* `bundle exec rake bot:birthday`
