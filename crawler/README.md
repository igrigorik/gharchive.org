# Crawler

GitHub activities are archived by periodically polling the [Events API](https://developer.github.com/v3/activity/events/) and archiving the raw responses into hourly archives - i.e. no additional post processing is done.

For details on how to fetch the archived data, see www.gharchive.org.

## Install

You may need to install openssl to install eventmachine correctly.

```sh
sudo apt-get install openssl-dev
OR
sudo dnf install openssl-devel
```

Then you can install the ruby gems like so:

```sh
gem install bundler:1.16.1
bundle install
```

## Run Crawler

```sh
bundle exec ruby crawler.rb
```