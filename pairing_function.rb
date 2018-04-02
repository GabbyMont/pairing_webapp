def random_array(names)
	random_name_array = names.shuffle.each_slice(2).to_a
	if names.size % 2 == 0
		random_name_array
	else
		random_name_array[-2] << random_name_array[-1] #takes second to last element and adds last element into it
		random_name_array[-2].flatten! #flattens second to last element to make it one array
		random_name_array.pop #takes off last element of array that was not removed
		random_name_array
	end
end

# print random_array(["Eden", "Persephone", "Celeste", "Leopold", "Amethyst", "Davy", "Cosmo", "Loki"])