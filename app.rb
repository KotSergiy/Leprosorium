#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db=SQLite3::Database.new 'leprosorium.db'
	@db.results_as_hash=true
end

configure do
	init_db
	@db.execute 'CREATE TABLE IF NOT EXISTS Posts
		(
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			created_date DATE,
			content TEXT
		)'
end

before do
	init_db
end

get '/' do
	@data_db=@db.execute 'SELECT * FROM Posts ORDER BY id DESC'

	erb :index
end

get '/new' do
  erb :new
end

post '/new' do
	@content=params[:content]

	if @content.length < 1
		@error='Type post text'
		erb :new
	else
		@db.execute 'INSERT INTO Posts (content,created_date) VALUES (?, datetime())', [@content]

		redirect to '/'
	end
end

get '/details/:post_id' do
	post_id=params[:post_id]	# Получить значение из URL'а

	data_db=@db.execute 'SELECT * FROM Posts WHERE id=?', [post_id]
	@row=data_db[0]

	erb :details
end

post '/details/:post_id' do
	post_id=params[:post_id]	# Получить значение из URL'а
	content=params[:content]

	erb "You taped #{content} for post #{post_id}"
end
