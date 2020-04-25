extends Node2D

onready var board = $Board
onready var pieces = $Pieces.get_children()

var currently_selected_piece = null
var currently_selected_squares = null

func _ready():	
	for piece in pieces:
		piece.connect("selected", self, "_on_piece_selected")
		piece.connect("deselected", self, "_on_piece_deselected")
		#print(piece.name, "'s position is ", piece.position, " and its square coords are ", piece.board_coords, " which is at ", board.get_square(piece.board_coords).position)
		piece.position = board.get_square(piece.board_coords).position

func _on_piece_selected(piece):	
	#Update pieces state
	pieces = $Pieces.get_children()
	
	print(piece.name, " selected at ", piece.board_coords)
	
	for p in pieces:
		if p.name != piece.name && p.selected:
			p.set_selected(false)
	
	if (currently_selected_squares != null):
		for squares in currently_selected_squares:
			squares.set_selected(false)
	
	var available_squares_list = available_squares(piece.board_coords)
	
	for squares in available_squares_list:
		squares.set_selected(true)
	
	currently_selected_piece = piece
	currently_selected_squares = available_squares_list
	
func _on_piece_deselected(piece):
	print(piece.name, " deselected")
	
	piece.set_selected(false)
	
	for squares in currently_selected_squares:
		squares.set_selected(false)
	
	currently_selected_piece = null
	currently_selected_squares = null

func available_squares(square_name):
	var available_square_list = []
	
	var square_index = board.name2dictIndex(square_name)
	var row = square_index.row
	var column = square_index.column
	
	#Up Left
	if is_valid_array_square(row-1,column-1):
		available_square_list.append(board.squares_array[row-1][column-1])
	
	#Up
	if is_valid_array_square(row-1,column):
		available_square_list.append(board.squares_array[row-1][column])
	
	#Up Right
	if is_valid_array_square(row-1,column+1):
		available_square_list.append(board.squares_array[row-1][column+1])
	
	#Left
	if is_valid_array_square(row,column-1):
		available_square_list.append(board.squares_array[row][column-1])
	
	#Right
	if is_valid_array_square(row,column+1):
		available_square_list.append(board.squares_array[row][column+1])
	
	#Down Left
	if is_valid_array_square(row+1,column-1):
		available_square_list.append(board.squares_array[row+1][column-1])
		
	#Down
	if is_valid_array_square(row+1,column):
		available_square_list.append(board.squares_array[row+1][column])
		
	#Down Right
	if is_valid_array_square(row+1,column+1):
		available_square_list.append(board.squares_array[row+1][column+1])
	
	return available_square_list

func is_valid_array_square(row, column):
	#Test whether the array indexes are valid
	if (row >= 8 || column >= 10 || row < 0 || column < 0):
		return false
	
	var square_name = board.squares_array[row][column].name
	print("testing ", square_name)
	
	#Test whether the square colour prevents piece from moving there
	
	#Test whether a piece occupies the square
	for p in pieces:
		if p.board_coords == square_name:
			print(square_name, " occupied by ", p.name)
			return false
	return true
	
func _on_board_clicked(square, square_indexes):
	pass # Replace with function body.

