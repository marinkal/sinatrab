#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
  @db = SQLite3::Database.new "BarberShop.db"
 @db.execute  "CREATE TABLE IF NOT EXISTS Users ( id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, 
  Name TEXT NOT NULL, DateStamp TEXT, Barber TEXT, Color TEXT )";
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School!!!</a>"			
end


get '/about' do
    @error = 'something wrong'
    erb :about

end


get '/visit' do
  erb :visit
end

post '/visit' do
 
  @barber = params[:barber]
  @name = params[:username]
  @phone = params[:phone]
  @date = params[:date]
  @time = params[:time]
  @color = params[:color]
  hh = {:username => 'Введите имя',:phone => 'Введите телефон',:date => 'Введите дату', :time => 'Введите время'}
  @error=hh.select{|key,_|params[key].strip==""}.values.join(",")
  if @error != ""
    return erb :visit 
  else 
  #f=File.open("./public/clients.txt","a")
  #f.write("#{@barber}, #{@name}, #{@phone}, #{@date}, #{@time}\n")
  #f.close
  #@db.execute 'insert into users(name,barber,phone,DateStamp,color) Values(?,?,?,?,?)',[@name,@barber,@phone,@date+' '+@time,@color]
 # @db.execute  'insert into Users(name,barber,phone,DataStamp,color) Values(?,?,?,?,?,)',[@name,@barber,@phone,@date + ' '+@time,@color]
    
 
  erb "Поздравляем! Вы запиисаны к парикмахеру #{@barber}, на #{@date}#{@time}, вы выбрали цвет #{@color} "
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
    erb "<a href='./clients.txt'>Тут клиенты</a>"
  else
    @title='Доступ запрещен'
    @message='К сожалению, ваш логин или пароль неверны'
    erb :message
  end

end