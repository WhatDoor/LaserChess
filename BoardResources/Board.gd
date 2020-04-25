extends Node2D

var squares_array = [[],[],[],[],[],[],[],[]]

signal board_clicked(square, square_indexes)

func _ready():
	for N in $Squares.get_children():
		N.connect("clicked", self, "_on_square_clicked")
	initalize_squares_array($Squares.get_children())

func initalize_squares_array(squares):
	var iterator = 0
	for N in squares:
		squares_array[iterator].append(N)
		iterator += 1
		
		if iterator >= 8:
			iterator = 0
	
func _on_square_clicked(square):
	var square_indexes = name2dictIndex(square.name)
	#print(squares_array[square_indexes.row][square_indexes.column].name)
	emit_signal("board_clicked", square, square_indexes)
	
func get_square(square_name):
	var square_indexes = name2dictIndex(square_name)
	return squares_array[square_indexes.row][square_indexes.column]
	
func name2dictIndex(square_name):
	var row = convert_row_index(square_name[1])
	var column = convert_column_index(square_name[0])
	
	return {"row":row, "column":column}

func convert_row_index(orig_row_index):
	return 8 - int(orig_row_index)

func convert_column_index(orig_column_index):
	match (orig_column_index):
		"A":
			return 0
		"B":
			return 1
		"C":
			return 2
		"D":
			return 3
		"E":
			return 4
		"F":
			return 5
		"G":
			return 6
		"H":
			return 7
		"I":
			return 8
		"J":
			return 9
