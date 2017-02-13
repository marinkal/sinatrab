#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
def is_barber_exists? db,barber
  db = get_db
  return db.execute('select * from Barbers where name=?',[barber]).length>0
end
def  seed_db db
  db = get_db
  barbers = ['Jessie Pikman','Maria Kolt','Ivan Razin','Irina Bespalova'];
  barbers.each do |barber|
    if !is_barber_exists? db,barber
      db.execute 'Insert Into Barbers (name) Values(?)',[barber]
    end
  end
  db.close
end

def get_db
 db=SQLite3::Database.new "BarberShop.db"
 db.results_as_hash = true
 return db
end
configure do
   db = get_db
    db.execute 'CREATE TABLE IF NOT EXISTS
        "Users"
        (
            "id" INTEGER PRIMARY KEY AUTOINCREMENT,
            "name" TEXT,
            "phone" TEXT,
            "datestamp" TEXT,
            "barber" TEXT,
            "color" TEXT
        )'

  db.execute 'CREATE TABLE IF NOT EXISTS
      "Barbers"
      (
          "id" INTEGER PRIMARY KEY AUTOINCREMENT,
          "name" Text
      )'
seed_db db
  end
 




#configure do
 # @db = SQLite3::Database.new "BarberShop.db"
 #@db.execute  "CREATE TABLE IF NOT EXISTS Users ( id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, 
 # Name TEXT NOT NULL, DateStamp TEXT, Barber TEXT, Color TEXT )";
#end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School!!!</a>"			
end


get '/about' do
    @error = 'something wrong'
    erb :about

end


before '/visit' do
 db = get_db
  @barbers = db.execute 'select * from barbers order by name'
  db.close
end
 
get '/visit' do
  erb :visit
end

post '/visit' do
 
  @barber = params[:barber]
  @name = params[:username]
  @phone = params[:phone]
  @date = params[:date]
  @color = params[:color]
 
  hh = {:username => 'Введите имя',:phone => 'Введите телефон',:date => 'Введите дату'}
  @error=hh.select{|key,_|params[key].strip==""}.values.join(",")
  if @error != ""
    return erb :visit 
  else 
  #f=File.open("./public/clients.txt","a")
  #f.write("#{@barber}, #{@name}, #{@phone}, #{@date}, #{@time}\n")
  #f.close
  #@db.execute 'insert into users(name,barber,phone,DateStamp,color) Values(?,?,?,?,?)',[@name,@barber,@phone,@date+' '+@time,@color]
 # @db.execute  'insert into Users(name,barber,phone,DataStamp,color) Values(?,?,?,?,?,)',[@name,@barber,@phone,@date + ' '+@time,@color]
  db = get_db
  db.execute 'insert into users(name,barber,phone,datestamp,color) Values(?,?,?,?,?)',[@name,@barber,@phone,@date,@color]
  db.close
 
  erb "Поздравляем! Вы запиисаны к парикмахеру #{@barber}, на #{@date}, вы выбрали цвет #{@color} "
  end
end

get '/contacts' do
  erb :contacts
end

post '/contacts' do
 @username = params[:username]
  @email = params[:email]
  @comment = params[:comment]
 @error = ""
 hh = {:username => 'ВВедите ваше имя', :email => 'Введите ваш e-mail', :comment => 'Введите комментарий'}
 @error = hh.select{|key, |params[key].strip==""}.values.join(", ")
 if @error!=""
   return erb :contacts
  else
     Pony.mail(:to => "Marin.ty.ka@gmail.com", :from => @email, :subject => "art inquiry from #{@username}",:body => "#{@comment}")
     haml :contact
    @title = 'yes!'
    @message = 'cool'
    erb :message
 end

end

get '/admin' do
  erb :admin
end


post '/admin' do
  @login = params[:login]
  @password = params[:password]
  if @login=='admin' && @password == 'secret'
    erb "<a href='/showusers'>Тут клиенты</a>"
  else
    @title='Доступ запрещен'
    @message='К сожалению, ваш логин или пароль неверны'
    erb :message
  end

end


get '/showusers' do
  db = get_db
  @results = db.execute "Select * from users order by id DESC"
  erb :showusers
  end