require 'sinatra'
require 'sqlite3'
require 'slim'
require 'sinatra/reloader'

get("/") do
  db = SQLite3::Database.new("db/todos.db")
  db.results_as_hash = true
 
  @todo = db.execute("SELECT * FROM todos")
 #query = params[:q]
 #if query && !query.empty?
  # @todo = db.execute("SELECT * FROM todos WHERE name LIKE ? ","%#{query}%")
 #else
 # @todo = db.execute("SELECT * FROM todos")
 #end
  slim(:"todos/index")
end  

get("/todos/:id/edit") do
  id = params[:id].to_i

  db = SQLite3::Database.new("db/todos.db")
  db.results_as_hash = true
  @selected_todo = db.execute("SELECT * FROM todos WHERE id = ?", id).first
  slim(:"todos/edit")

end

post("/todos/:id/delete") do
  db = SQLite3::Database.new('db/todos.db')
  denna_ska_bort = params[:id].to_i
  db.execute("DELETE FROM todos WHERE id = ?", denna_ska_bort)
  redirect('/')
end

get('/todos/new') do
  slim(:"todos/new")
end
post('/todo') do
  new_todo = params[:new_todo] # Hämta datan ifrån formuläret
  description = params[:description].to_i 
  db = SQLite3::Database.new('db/todos.db') # koppling till databasen
  db.execute("INSERT INTO todos (name, description) VALUES (?,?)",[new_todo, description])
  redirect('/') # Hoppa till routen som visar upp alla frukter
 
end

post("/todos/:id/update") do
  db = SQLite3::Database.new("db/todos.db")
  id = params[:id].to_i
  name = params[:name]
  description = params[:description]
  db.execute("UPDATE todos SET name=?, description=? WHERE id=?", [name, description, id])
  redirect("/")
end

# Funktion för att prata med databasen
# Exempel på användning: db.execute('SELECT * FROM fruits')

# Routen /
#get '/' do
#    slim(:index)
#end


