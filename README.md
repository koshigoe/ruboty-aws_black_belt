# Ruboty::AwsBlackBelt

Ruboty plugin for AWS Black Belt online seminar.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruboty-aws_black_belt'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruboty-aws_black_belt

## Usage

```
ruboty /awsbb list/ - Show AWS Black Belt schedule
ruboty /awsbb profile\z/ - Show profile
ruboty /awsbb profile\n(?<profile>.*)\z/m - Save profile
ruboty /awsbb register (?<url>.*)/ - Register webinar
```

### Profile

To register webinar via Slack bot, you must save profile.

```
電子メールアドレス =
名 =
姓 =
国 =
郵便番号 =
勤務先お電話番号 =
御社名・所属団体名 =
お役職 =
業種 =
職種 =
AWS 利用度 =
クラウド導入の予定はいつですか？ =
オンラインセミナー後、AWS の日本担当チームからご連絡させていただいてもよろしいですか =
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/koshigoe/ruboty-aws_black_belt.

