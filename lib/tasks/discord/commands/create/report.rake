desc 'Creates /report command'
namespace :discord do
  namespace :commands do
    namespace :create do
      task report: :environment do
        command = DiscordEngine::Commands::ChatInput.new(
          name: 'report',
          description: 'creates a report of all the news from the companies connected to OSNews'
        )
        creation_response = command.create

        puts "Command created! id: #{creation_response['id']}"
      rescue DiscordEngine::CommandCreationFailed => e
        puts e.message
      end
    end
  end
end
