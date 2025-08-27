# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "faker"

Project.delete_all
Todo.delete_all

puts "🌱 Seeding database..."

5.times do
  project = Project.create!(
    name: Faker::App.name,
    description: Faker::Lorem.paragraph(sentence_count: 2),
    status: Project.statuses.values.sample,
    start_date: Faker::Date.backward(days: 30),
    due_date: Faker::Date.forward(days: 60)
  )

  rand(5..10).times do
    project.todos.create!(
      title: Faker::Lorem.sentence(word_count: 3),
      description: Faker::Lorem.paragraph,
      status: Todo.statuses.values.sample,
      priority: Todo.priorities.values.sample,
      due_date: Faker::Date.forward(days: 30),
      starts_at: Faker::Time.backward(days: 10),
      completed_at: [nil, Faker::Time.forward(days: 5)].sample,
      estimate_minutes: rand(30..240),
      time_spent_minutes: rand(0..240)
    )
    
  end
end

puts "✅ Done seeding!"