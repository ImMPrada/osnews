# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


### Deploy

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
