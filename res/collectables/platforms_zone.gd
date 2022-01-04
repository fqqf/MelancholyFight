extends Node

const platforms = {
	"0": [
		[5],#quantity levels
		[3,3,3,3,3,3],#position 0-top - 5 bottom
		[30,0,0] #leght platform, gap if 0 - standart, if 0 leght platform*speed/1 - 30*UBLOCK_SIZE
	],
		
	"1": [
		[4],
		[2,3,4,3],
		[30,0,0]
	],
	"2": [
		[4],
		[2,1,0,1],
		[30,0,0]
	],
	"3": [
		[4],
		[2,1,0,1,2,3,4,3 ],
		[30,0,0]
	],
	"4": [
		[5],#quantity levels
		[0,1,2,3],#position 0-top - 5 bottom
		[40,1,0] #leght platform, gap if 0 - standart
	],
	"5": [
		[5],
		[5,0,5,0,5,0,3 ],
		[3,0,1]
	],
	"6": [
		[5],
		[4,0,4,0,4,0,4 ],
		[1,0,1]
	],
	}





