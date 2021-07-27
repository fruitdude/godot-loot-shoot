extends TextureRect
#what occupies the grid space ?

var items = []

var grid = {}
var cell_size = 32
var grid_width = 0
var grid_height = 0
var toggle_item_rotation = false


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("item_grabbed", self, "_on_item_grabbed")
	var s = get_grid_size(self)
	grid_width = s.width
	grid_height = s.height
	create_empty_grid()
	

func _physics_process(_delta):
	if Input.is_action_just_pressed("drop_item"):
		var item = get_item_under_pos(get_global_mouse_position())
		if item == null:
			return

		var item_pos = item.rect_global_position + Vector2(cell_size/2, cell_size/2)
		var g_pos = pos_to_grid_coord(item_pos)
		var item_size_in_cells = get_grid_size(item)
		set_grid_space(g_pos, item_size_in_cells, false)
		GameEvents.emit_signal("item_dropped", item.item)
		items.remove(items.find(item))
		item.queue_free()
		item = null


func create_empty_grid():
	for x in range(grid_width):
		grid[x] = {}
		for y in range(grid_height):
			grid[x][y] = false  # mark this grid cell as empty (occupied = "false")
			
			
func insert_item(item):
	# set item_pos to the center of the top-left cell
	var item_pos = item.rect_global_position + Vector2(cell_size/2, cell_size/2)
	var g_pos = pos_to_grid_coord(item_pos)
	var item_size_in_cells = get_grid_size(item)
	
	if is_grid_space_available(g_pos, item_size_in_cells):
		set_grid_space(g_pos, item_size_in_cells, true)
		item.rect_global_position = rect_global_position + Vector2(g_pos.x, g_pos.y) * cell_size
		items.append(item) #adds an item to the array of items
		return true
	else:
		return false
		
	
func grab_item(pos):
	var item = get_item_under_pos(pos)
	if item == null:
		return null
		
	var item_pos = item.rect_global_position + Vector2(cell_size/2, cell_size/2)
	var g_pos = pos_to_grid_coord(item_pos)
	var item_size_in_cells = get_grid_size(item)
	set_grid_space(g_pos, item_size_in_cells, false)
	
	items.remove(items.find(item))
	
	return item
	
	
func get_item_under_pos(pos):
	for item in items:
		if item.get_global_rect().has_point(pos):
			return item
	return null
	
	
func set_grid_space(pos, item_size_in_cells, state):
	for i in range(pos.x, pos.x + item_size_in_cells.width):
		for j in range(pos.y, pos.y + item_size_in_cells.height):
			grid[i][j] = state
			
	
func is_grid_space_available(pos, item_size_in_cells):
	if pos.x < 0 or pos.y < 0:
		return false
	if pos.x + item_size_in_cells.width > grid_width or pos.y + item_size_in_cells.height > grid_height:
		return false
		
	# check every cell in the grid if it's occupied	
	for i in range(pos.x, pos.x + item_size_in_cells.width):
		for j in range(pos.y, pos.y + item_size_in_cells.height):
			if grid[i][j]:  # is occupied already
				return false
	return true
	
	
func pos_to_grid_coord(pos):
	var local_pos = pos - rect_global_position
	var results = {}
	results.x = int(local_pos.x / cell_size)
	results.y = int(local_pos.y / cell_size)
	return results
	

func get_grid_size(item):
# return the item's size in units of cell_size
	var results = {}
#	print(results)
	var s = item.rect_size
#	print(s)
	results.width = clamp(int(s.x / cell_size), 1, 500)
#	print(results.width)
	results.height = clamp(int(s.y / cell_size), 1, 500)
#	print(results.height)
#	print(results)
	return results
	
	
func insert_item_at_first_available_spot(item):
	for y in range(grid_height):
		for x in range(grid_width):
			if !grid[x][y]:
				item.rect_global_position = rect_global_position + Vector2(x, y) * cell_size
				if insert_item(item):
					return true
	return false


func _on_item_grabbed(item):
	if Input.is_action_just_pressed("jump") and toggle_item_rotation:
		_rotate_item(item, "asset_vertical")
	elif Input.is_action_just_pressed("jump") and not toggle_item_rotation:
		_rotate_item(item, "asset_horizontal")
		


func _rotate_item(item, image_orientation : String):
	toggle_item_rotation = !toggle_item_rotation #toggling var between true and false
	if item == null: #if there is no item return
		return
	item.texture = load(ItemDB.get_item(item.item)[image_orientation]) #loading the image from the ItemDB
	item.rect_size = Vector2(0, 0) #resetting the items rect_size (i have no idea why i have to do that)
	get_grid_size(item) #recualculating the items grid_size
