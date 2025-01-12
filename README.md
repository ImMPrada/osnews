# OSNews

A Rails application that monitors and notifies about new Apple operating system releases through Discord. It fetches information from Apple's RSS feed and sends notifications to configured Discord channels when new versions are available.

## Features

- Monitors Apple's official RSS feed for new OS releases
- Supports multiple operating systems (iOS, iPadOS, macOS, tvOS, visionOS, watchOS)
- Sends notifications to Discord channels
- Runs background jobs for automated monitoring
- Built with Rails 8.0

## Requirements

- Ruby 3.2.2
- PostgreSQL
- Discord Bot Token and Channel configuration

## Stack

- Rails 8.0
- Delayed Jobs
- [Discord](https://discord.com/developers/applications)
- [bro-garden/discord-engine](https://github.com/bro-garden/discord-engine)
- RSpec

## Local setup

1. Clone the repository
2. Install dependencies:
```bash
bundle install
```
3. Setup the database:
```bash
bin/rails db:create
bin/rails db:schema:load
```
4. Configure environment variables:
Create a `.env` file based on the `.env.example` file.

5. Start the server:
```bash
rails s
```

6. Start the job processor:
```bash
bundle exec rake jobs:work
```

7. You need to create a port for the webhook in Discord. For example yo can use ngrok
```bash
ngrok http 3000
```

8. At Discord dashboard you need to create a webhook and set the url to the ngrok url.

### Running Tests

```bash
bundle exec rspec
```

### Background Jobs

The application uses Delayed Job for background job processing. The jobs will be automatically processed as they are part of the Rails application. The jobs are stored in the database, so no additional infrastructure is required beyond PostgreSQL.

To monitor and manage background jobs, you can use the Rails console:

```bash
bin/rails c
Delayed::Job.count         # Check number of pending jobs
Delayed::Job.last.handler  # Inspect the last job
```

### Tasks

The repo has some rake tasks:

To create a command in Discord you should create a rake task, for example the repo has a task to create a `/connect` command, `/report` command:

```bash
bundle exec rake discord:commands:create:connect
bundle exec rake discord:commands:create:report
```

To pull first versions of the OS releases and enqueue the jobs:

```bash
bundle exec rake jobs:enqueue_apple_rss
```

## Deploy

This application is deployed using [Fly.io](https://fly.io), a platform that makes it easy to deploy and run applications globally. Fly.io allows us to deploy our Docker containers close to our users, providing fast response times and reliable service.

Before deploying, make sure you have:
1. Created a Fly.io account
2. Installed the Fly CLI (`flyctl` or `fly`)
3. Authenticated

```bash
fly auth login
```
4. Created an app

```bash
fly launch
```

To deploy the application, use the following command, replacing the build args with your GitHub credentials to access private packages:

```bash
fly deploy --build-arg GITHUB_USERNAME= --build-arg GITHUB_TOKEN=
```

To connect to console:

```bash
fly ssh console
```

Then we can run rake tasks, or even access to the console of the running container:

## License

This project is licensed under the MIT License.
