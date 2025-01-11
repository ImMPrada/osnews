DiscordEngine.public_key = ENV['DISCORD_PUBLIC_KEY']
DiscordEngine.bot_token = ENV['DISCORD_TOKEN']
DiscordEngine.application_id = ENV['DISCORD_APP_ID']

DiscordEngine.resolvers = [
  'Resolvers::Connect'
]
