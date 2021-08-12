# Roue Libre

Roue Libre (RL) is a ruby Twitter bot posting random quotes.

RL can fetch quotes from both HTTP or a plain text file.

## Getting Started

### Prerequisites

- [Ruby](https://www.ruby-lang.org/fr/)
- [Bundler](https://bundler.io/)

### Install

```sh
bundle install
```

### File Format

File format should be as follow: **one line per quote** (http or plain text)

```text
quote1
quote2
...
quoteN
```

### Environment variables

Twitter secrets are passed using the following environment variables :

- CONSUMER_KEY
- CONSUMER_SECRET
- ACCESS_TOKEN
- ACCESS_TOKEN_SECRET

See [Twitter documentation](https://developer.twitter.com/en/docs/authentication/oauth-1-0a) for details.

### Usage (cli mode)

```sh
bundle exec ruby bin/rl.rb --help
```

#### Docker container

RL can be used directly within a [Docker container](https://hub.docker.com/r/papey/rl) (builded from my [personnal CI](https://drone.github.papey.fr/papey/rl)).

```bash
docker run -e CONSUMER_KEY=$CONSUMER_KEY -e CONSUMER_SECRET=$CONSUMER_SECRET -e ACCESS_TOKEN=$ACCESS_TOKEN -e ACCESS_TOKEN_SECRET=$ACCESS_TOKEN_SECRET papey/rl -u https://url.example.com/text.txt
```

#### Periodic runs

Here is an example using **systemd-timers**

Service unit `rl.service`:

```text
[Unit]
Description=Roue Libre

[Service]
ExecStart=docker run -e CONSUMER_KEY=$(CONSUMER_KEY) -e CONSUMER_SECRET=$(CONSUMER_SECRET) -e ACCESS_TOKEN=$(ACCESS_TOKEN) -e ACCESS_TOKEN_SECRET=$(ACCESS_TOKEN_SECRET) papey/rl:latest -u https://url.example.com/text.txt
Environment=CONSUMER_KEY=CONSUMER_KEY
Environment=CONSUMER_SECRET=CONSUMER_SECRET
Environment=ACCESS_TOKEN=ACCESS_TOKEN
Environment=ACCESS_TOKEN_SECRET=ACCESS_TOKEN_SECRET

[Install]
WantedBy=multi-user.target
```

Timer unit `rl.timer`

```text
[Unit]
Description=Roue Libre Timer

[Timer]
OnCalendar=00/2:42
Persistent=true

[Install]
WantedBy=timers.target
```

## Authors

- **Wilfried OLLIVIER** - _Main author_ - [Papey](https://github.com/papey)

## License

[LICENSE](LICENSE) file for details
