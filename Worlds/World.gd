extends Node2D

enum COLOUR {
	RED = 1,
	BLUE = 2
}

onready var board = $Board
onready var pieces = $Board_Objects/Pieces.get_children()

var currently_selected_piece = null
var currently_selected_squares = null
var currently_swappable_pieces = null

var myLaser

func _ready():	
	#Connect signal handlers for each piece and place each piece in the correct position on the board
	for piece in pieces:
		piece.connect("selected", self, "_on_piece_selected")
		piece.connect("deselected", self, "_on_piece_deselected")
		
		if piece.get_type() == "DEFENDER" or piece.get_type() == "DEFLECTOR":
			piece.connect("swap_clicked", self, "_on_swappable_piece_clicked")
		
		piece.position = board.get_square(piece.board_coords).position
		
		# Set owners of pieces - Server is always red
		if get_tree().is_network_server():
			if piece.team_colour == COLOUR.RED:
				piece.set_network_master(get_tree().get_network_unique_id())
			else:
				piece.set_network_master(Helper.opponent_id)
		else:
			if piece.team_colour == COLOUR.BLUE:
				piece.set_network_master(get_tree().get_network_unique_id())
			else:
				piece.set_network_master(Helper.opponent_id)
	
	#Set Owners of lasers
	if get_tree().is_network_server():
		$Board_Objects/RedLaser.set_network_master(get_tree().get_network_unique_id())
		myLaser = $Board_Objects/RedLaser
		
		$Board_Objects/BlueLaser.set_network_master(Helper.opponent_id)
	else:
		$Board_Objects/RedLaser.set_network_master(Helper.opponent_id)
		
		$Board_Objects/BlueLaser.set_network_master(get_tree().get_network_unique_id())
		myLaser = $Board_Objects/BlueLaser

func _process(delta):
	if Input.is_action_pressed("End_Turn"):
		end_turn()

func _on_swappable_piece_clicked(click_piece):
	print("Swapping ", currently_selected_piece.name, " with ", click_piece.name)
	
	#Save the Switch's position and square
	var currently_selected_piece_position = currently_selected_piece.position
	var currently_selected_piece_square = currently_selected_piece.board_coords
	
	#Swap currently selected piece with click piece
	rpc("move_piece", currently_selected_piece.name, click_piece.board_coords)
	
	#Swap click piece with currently selected piece
	rpc("swap_piece", click_piece.name, currently_selected_piece_square)
	
	#Unselect/Highlight Switch and piece
	_on_piece_deselected(currently_selected_piece)
	click_piece.make_swappable(false)

func _on_board_clicked(square, square_indexes):
	handle_board_click(square, square_indexes)

func handle_board_click(square, square_indexes):
	#print(square.name, " clicked")
	
	#If a piece has been selected and a highlighted square is chosen, then move the piece to that square
	if currently_selected_piece != null and square_exists_in(currently_selected_squares, square):
		print("moving ", currently_selected_piece.name, " to ", square.name)
		rpc("move_piece", currently_selected_piece.name, square.name)
		_on_piece_deselected(currently_selected_piece)

remotesync func move_piece(piece_name, square_name):
	#Getting object from names because passing objects over network is unsafe
	var piece = $Board_Objects/Pieces.get_node(piece_name)
	var square = board.get_square(square_name)
	
	#piece.position = square.position
	piece.board_coords = square.name
	
	var tween = get_node("Tween")
	
	#Slow moving on the ground
	if piece.get_type() == "KING":
		tween.interpolate_property(piece, "position",
			piece.position, square.position, 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	#Fast moving on the ground
	elif piece.get_type() == "DEFLECTOR":
		tween.interpolate_property(piece, "position",
				piece.position, square.position, .7,
				Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	
	#Float up and land with a smash
	elif piece.get_type() == "DEFENDER":
		var point_above_piece = Vector2(piece.position.x, piece.position.y - 9.5)
		var point_above_piece2 = Vector2(piece.position.x, piece.position.y - 10)
		var point_above_square = Vector2(square.position.x, square.position.y - 10)
		
		var animTime_1 = 1
		var animTime_2 = .5
		var animTime_3 = 1
		var animTime_4 = .15
		
		var DELAY_1 = animTime_1
		var DELAY_2 = DELAY_1 + animTime_2
		var DELAY_3 = DELAY_2 + animTime_3 + .2
		
		tween.interpolate_property(piece, "position",
				piece.position, point_above_piece, animTime_1,
				Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.interpolate_property(piece, "position",
				point_above_piece, point_above_piece2, animTime_2,
				Tween.TRANS_ELASTIC, Tween.EASE_OUT,
				DELAY_1)
		tween.interpolate_property(piece, "position",
				point_above_piece2, point_above_square, animTime_3,
				Tween.TRANS_QUAD, Tween.EASE_IN_OUT, 
				DELAY_2)
		tween.interpolate_property(piece, "position",
				point_above_square, square.position, animTime_4,
				Tween.TRANS_QUAD, Tween.EASE_IN,
				DELAY_3)
	
	#Warps
	elif piece.get_type() == "SWITCH":
		piece.position = square.position
	
	else:
		tween.interpolate_property(piece, "position",
				piece.position, square.position, 1,
				Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)

	tween.start()

remotesync func swap_piece(piece_name, square_name):
	#Getting object from names because passing objects over network is unsafe
	var piece = $Board_Objects/Pieces.get_node(piece_name)
	var square = board.get_square(square_name)
	
	#piece.position = square.position
	piece.board_coords = square.name
	
	#Will eventually replace this with warping animation
	piece.position = square.position

func _on_piece_selected(piece):	
	print(piece.name, " selected at ", piece.board_coords)
	
	#Update state of pieces list
	pieces = $Board_Objects/Pieces.get_children()
	
	#Deselect any other piece that that is currently selected
	for p in pieces:
		if p.name != piece.name && p.selected:
			p.set_selected(false)
	
	#Deselect any other squares that are currently selected
	if currently_selected_squares != null:
		for squares in currently_selected_squares:
			squares.set_selected(false)
			
	#Make any currently swappable pieces unswappable - only relevant to Switch
	if currently_swappable_pieces != null:
		for p in currently_swappable_pieces:
			p.make_swappable(false)
	
	#Set the currently selected piece
	currently_selected_piece = piece
	
	#Set the currently available squares
	currently_selected_squares = available_squares(piece.board_coords)
	
	#Highlight the currently available squares
	for squares in currently_selected_squares:
		squares.set_selected(true)
	
	#Set the currently swappable pieces - only relevant to Switch
	currently_swappable_pieces = get_swappable_pieces(piece)
	
	#Make the currently swappable pieces swappable - only relevant to Switch
	for p in currently_swappable_pieces:
		p.make_swappable(true)

func get_swappable_pieces(piece):
	var swappable_pieces = []
	
	#Check if piece is a switch, skip this function if not
	if piece.get_type() == "SWITCH":
		
		#Get surrounding squares of piece
		var surrounding_squares = get_surrounding_squares(piece.board_coords)
	
		#Check if any pieces occupy those squares, and whether they are defender or deflector
		for square in surrounding_squares:
			for p in pieces:
				if square != null and p.board_coords == square.name and (p.get_type() == "DEFENDER" or p.get_type() == "DEFLECTOR"):
					#Check if the piece is standing on their coloured square and that the switch is not that colour, piece should not be swappable if true
					if p.team_colour == square.colour and piece.team_colour != square.colour:
						pass
					else:
						#Add those pieces to the list
						swappable_pieces.append(p)
	
	return swappable_pieces
	
func _on_piece_deselected(piece):
	print(piece.name, " deselected")
	
	#Deselect the piece
	piece.set_selected(false)
	
	#Deselect the selected squares
	for squares in currently_selected_squares:
		squares.set_selected(false)
		
	#Make any currently swappable pieces unswappable - only relevant to Switch
	for p in currently_swappable_pieces:
		p.make_swappable(false)
	
	#Unset the currently selected/highlighted pieces and squares
	currently_selected_piece = null
	currently_selected_squares = null
	currently_swappable_pieces = null


func get_surrounding_squares(square_name):
	var surrounding_squares = []
	
	var square_index = board.name2dictIndex(square_name)
	var row = square_index.row
	var column = square_index.column
	
	#Up Left
	surrounding_squares.append(board.get_square_from_array(row-1,column-1))
	
	#Up
	surrounding_squares.append(board.get_square_from_array(row-1,column))
	
	#Up Right
	surrounding_squares.append(board.get_square_from_array(row-1,column+1))
	
	#Left
	surrounding_squares.append(board.get_square_from_array(row,column-1))
	
	#Right
	surrounding_squares.append(board.get_square_from_array(row,column+1))
	
	#Down Left
	surrounding_squares.append(board.get_square_from_array(row+1,column-1))
		
	#Down
	surrounding_squares.append(board.get_square_from_array(row+1,column))
		
	#Down Right
	surrounding_squares.append(board.get_square_from_array(row+1,column+1))
	
	return surrounding_squares
	
func available_squares(square_name):
	var available_square_list = []
	var surrounding_squares = get_surrounding_squares(square_name)
	
	for square in surrounding_squares:
		if (square != null and is_valid_array_square(square.name)):
			available_square_list.append(square)
	
	return available_square_list

func is_valid_array_square(square_name):
	var square_index = board.name2dictIndex(square_name)
	var row = square_index.row
	var column = square_index.column
	
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
			return false
	
	return true

func square_exists_in(square_list, square):
	for s in square_list:
		if s.name == square.name:
			return true
	return false
	
func _on_Button_pressed():
	end_turn()

func end_turn():
	myLaser.rpc("fire_blast")
