extends Node


func _ready():
	randomize()
	pass # Replace with function body.

#print(Utils.get_prob([-30,1000], [[-30,400,50], [401, 405, 400], [406,900,30],[901,1000,5]]))
	

func get_prob(all_range, range_percent):
	var sum_percent =0
	for percent in range_percent:
		sum_percent += percent[2]
	var find_percent = rand_range(0, sum_percent)
	for find_range in range_percent:
		find_percent -= find_range[2]
		if find_percent <=0: 
			assert( all_range[0] <= find_range[0] and find_range[0] <=all_range[1] and all_range[0] <= find_range[1] and find_range[1] <=all_range[1] )
			return int(round(rand_range(find_range[0], find_range[1])))
