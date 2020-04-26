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
	print(piece.name, " selected at ", piece.board_coords)
	
	#Update pieces state
	pieces = $Pieces.get_children()
	
	#Deselect any other piece that that is currently selected
	for p in pieces:
		if p.name != piece.name && p.selected:
			p.set_selected(false)
	
	#Deselect any other squares that are currently selected
	if (currently_selected_squares != null):
		for squares in currently_selected_squares:
			squares.set_selected(false)
	
	#Set the currently selected piece
	currently_selected_piece = piece
	
	#Set the currently available squares
	var available_squares_list = available_squares(piece.board_coords)
	currently_selected_squares = available_squares_list
	
	#Highlight the currently available squares
	for squares in available_squares_list:
		squares.set_selected(true)
	
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
	
	var square = board.squares_array[row][column]
	#print("testing ", square_name)
	
	#A8 and J1 are always not allowed
	if square.name == "A8" || square.name == "J1":
		print(square.name, " is disallowed because of laser turret")
		return false
	
	#Test whether the square colour prevents piece from moving there
	if square.colour != currently_selected_piece.team_colour && square.colour != square.SQUARE_COLOUR.NORMAL:
		print(square.name, " is disallowed because of colour")
		return false
	
	#Test whether a piece occupies the square
	for p in pieces:
		if p.board_coords == square.name:
			print(square.name, " occupied by ", p.name)
			#IF PIECE IS SWITCH, test if the occupying piece is not deflector and defender
			return false
	
	return true
	
func _on_board_clicked(square, square_indexes):
	if currently_selected_piece != null and square_exists_in(currently_selected_squares, square):
		print("moving ", currently_selected_piece.name, " to ", square.name)
		currently_selected_piece.position = square.position
		currently_selected_piece.board_coords = square.name
		_on_piece_deselected(currently_selected_piece)

func square_exists_in(square_list, square):
	for s in square_list:
		if s.name == square.name:
			return true
	return false
