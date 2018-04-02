require 'sinatra'
require_relative 'pairing_function.rb'

enable :sessions
# def random_array(names)
# 	random_name_array = names.shuffle.each_slice(2).to_a
# 	if names.size % 2 == 0
# 		random_name_array
# 	else
# 		random_name_array[-2] << random_name_array[-1] #takes second to last element and adds last element into it
# 		random_name_array[-2].flatten! #flattens second to last element to make it one array
# 		random_name_array.pop #takes off last element of array that was not removed
# 		random_name_array
# 	end
# end

get '/' do
	erb :give_name1
end

post '/username' do
	username = params[:username]
	# "First name here #{username}" => First name here 'input name'
	redirect '/getrandomnames?username=' + username
end

get '/getrandomnames' do
	username = params[:username]
	erb :get_random_names2, locals:{username:username}
end

post '/getrandomnames' do
	name1 = params[:name1]
	name2 = params[:name2]
	name3 = params[:name3]
	name4 = params[:name4]
	name5 = params[:name5]
	name6 = params[:name6]
	username = params[:username]
	array = [name1,name2,name3,name4,name5,name6]
	session[:name_array] = random_array(array)
	session[:liked_pairs] = []
	# "Your names are #{name1}, #{name2}, #{name3}, #{name4}, #{name5}, #{name6}"
	# p array
	# p array.class
	# p array.length
	# p "#{name_array}"
	redirect '/check?username=' + username
end

get '/check' do
	username = params[:username]
	erb :check_names, locals:{username:username}
end

post '/check_names' do
	username = params[:username]
	session[:pairs] = params[:teams]
	session[:pairs] = session[:pairs]

	temp_array = []
	session[:name_array].each do |name|
		temp_array.push(name.join(','))
	end
	session[:name_array] = temp_array


	leftovers = []
	session[:name_array].each do |pairs|
		if session[:pairs].include?(pairs) == false
			leftovers << pairs.split(',')
		else
			session[:liked_pairs] << pairs.split(',')
		end
	end

	session[:leftovers] = leftovers.flatten
	if session[:leftovers].length == 0
		redirect '/final_result?username=' + username
	else
		session[:name_array] = random_array(session[:leftovers])
		redirect '/check?username=' + username
	end
end

get '/final_result' do
	username = params[:username]
	erb :last_page, locals:{username:username, pairs: session[:liked_pairs]}
end 

post '/start_over_button' do
	redirect '/'
end

