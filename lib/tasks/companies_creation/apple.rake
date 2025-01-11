desc 'adds Apple company'

namespace :companies_creation do
  task apple: :environment do
    company = Company.create!(name: 'Apple')
    puts "Company created! id: #{company.id}"
  rescue ActiveRecord::RecordInvalid => e
    puts e.message
  end
end
