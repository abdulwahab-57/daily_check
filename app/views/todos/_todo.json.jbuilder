json.extract! todo, :id, :title, :project_id, :created_at, :updated_at
json.url todo_url(todo, format: :json)
