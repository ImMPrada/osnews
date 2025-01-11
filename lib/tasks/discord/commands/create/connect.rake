desc 'Creates /connect command'
namespace :discord do
  namespace :commands do
    namespace :create do
      task connect: :environment do
        command = DiscordEngine::Commands::ChatInput.new(
          name: 'connect',
          description: 'connects osnews with discord server channel'
        )
        creation_response = command.create

        puts "Command created! id: #{creation_response['id']}"
      rescue DiscordEngine::CommandCreationFailed => e
        puts e.message
      end
    end
  end
end
