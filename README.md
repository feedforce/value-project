# ValueProject

`ffvalue` broadcast.

## Setup

```
bin/setup
```

## Development

```
bin/console
```

## Run bot

```
bin/rubot
```

## Requirements
### Accounts

* [slack](https://feedforce.slack.com)
* [Google](https://console.developers.google.com/home)
   * You needs Oauth2.0 credentials.
   * **NOT** Service Account credentials.

### ENV

```
export SLACK_BOT_API_TOKEN        : Slack bot api token. Go to https://feedforce.slack.com/services, and see `Bots` integrations.
export SLACK_USER_API_TOKEN       : Slack user api token. Go to https://api.slack.com/web, and get your OAuth2 token.
export SLACK_NOTIFICATION_CHANNEL : Notification channel on slack.
export GOOGLE_CLIENT_ID           : Google client token via OAuth2. Get from https://console.developers.google.com/home
export GOOGLE_CLIENT_SECRET       : Google client secret via OAuth2. Get from https://console.developers.google.com/home
export GOOGLE_REFRESH_TOKEN       : Google refresh token via OAuth2.
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/feedforce/value_project. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

