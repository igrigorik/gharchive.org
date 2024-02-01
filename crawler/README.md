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
bundle install --path vendor/bundle
```

## Run Crawler

```sh
bundle exec ruby crawler.rb
```

## Environment Prepare
```sh
sudo apt-get install openssl libssl-dev
```

```sh
sudo apt-get install ruby-rubygems
```

```sh
sudo apt-get install ruby-dev
```

```sh
# root user
apt-get update && apt-get install -y build-essential
```

## Enviroment Vars
```sh
GITHUB_TOKEN=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
STATHATKEY=xxMC1g25fuqH7nbx
STATHATEMAIL=wanting@aspecta.id
```