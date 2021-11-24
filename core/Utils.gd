extends Node


func _ready():
	randomize()
	

#secure
#print(Utils.get_prob_s([-30,1000], [[-30,400,50], [401, 405, 400], [406,900,30],[901,1000,5]]))
func get_prob_s(all_range, range_percent):
	var sum_percent =0
	for percent in range_percent:
		sum_percent += percent[2]
	var find_percent = rand_range(0, sum_percent)
	for find_range in range_percent:
		find_percent -= find_range[2]
		if find_percent <=0: 
			assert( all_range[0] <= find_range[0] and find_range[0] <=all_range[1] and all_range[0] <= find_range[1] and find_range[1] <=all_range[1] )
			return int(round(rand_range(find_range[0], find_range[1])))

#unsecure
#print(Utils.get_prob([[-30,400,50], [401, 405, 400], [406,900,30],[901,1000,5]]))
func get_prob(range_percent):
	var sum_percent =0
	for percent in range_percent:
		sum_percent += percent[2]
	var find_percent = rand_range(0, sum_percent)
	for find_range in range_percent:
		find_percent -= find_range[2]
		if find_percent <=0: 
			return int(round(rand_range(find_range[0], find_range[1])))

#percent secure	
#print(Utils.get_prob_ps([-30,1000], [[10,30,50], [31, 60, 400], [61,85,30],[86,100,5]]))
func get_prob_ps(all_range, range_percent):
	var sum_percent =0
	var one_percent: float
	for percent in range_percent:
		sum_percent += percent[2]
	var find_percent = rand_range(0, sum_percent)
	for find_range in range_percent:
		find_percent -= find_range[2]
		if find_percent <=0:
			assert( 0 <= find_range[0] and find_range[0] <=100 and 0 <= find_range[1] and find_range[1] <=100 )
			one_percent = (float(abs(all_range[0])) + abs(all_range[1]))/100
			var new_range = [all_range[0]+(find_range[0]*one_percent), all_range[0]+(find_range[1]*one_percent)]
			return int(round(rand_range(new_range[0], new_range[1])))

