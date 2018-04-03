require 'sinatra'
require_relative 'pairing_function.rb'

enable :sessions
# def random_array(names) //// This is my pairing function(just here for reference)
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
	erb :give_name1 #transferring to 'give_name1' erb page
end

post '/username' do
	username = params[:username] # assigning params[:username] to 'username'
	# "First name here #{username}" => First name here 'input name'
	redirect '/getrandomnames?username=' + username #redirects to getrandomnames get and adding username
end

get '/getrandomnames' do
	username = params[:username] # continue 
	erb :get_random_names2, locals:{username:username}
end

post '/getrandomnames' do
	array = params[:new_name]
	username = params[:username]
	session[:name_array] = random_array(array)
	session[:liked_pairs] = []
	redirect '/check?username=' + username
end

get '/check' do
	username = params[:username]
	erb :check_names, locals:{username:username, pairs_array:session[:name_array]}
end

post '/check_names' do
	username = params[:username] #continuing use of username params(instead of session)
	session[:pairs] = params[:teams] 

	temp_array = []
	session[:name_array].each do |name|
		temp_array.push(name.join(','))
	end
	session[:name_array] = temp_array # Setting name_array session to the empty array
	leftovers = [] # Creating a new aray for left over pairs or pairs not selected by the user
	session[:name_array].each do |pairs| # Loop
		if session[:pairs].include?(pairs) == false # if the pairs do not match they are pushed into the leftovers array
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
	redirect '/getrandomnames'
end

