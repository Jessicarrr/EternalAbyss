extends Node
class_name AttackAnims

# Array to store references to attack animations
var attack_animations = []
var current_index = 0  # Index to keep track of the current attack

# Time before the queue resets, in seconds
var reset_time = 5.0
var last_consumed_time = 0.0

var sprite_node = null

func _ready():
	#populate_attacks()
	print("Metadata is ", self.get_meta("SpritePath"))
	sprite_node = self.get_node(self.get_meta("SpritePath"))
	pass
	
func populate_attacks():
	Debug.msg(Debug.ANIMATION, ["Populating attacks..."])
	
	var children = self.get_children()
	
	children.sort_custom(sort_by_name)
	
	for child in children:
		attack_animations.append(child)
		
	last_consumed_time = Time.get_ticks_msec()
	Debug.msg(Debug.ANIMATION, ["Attacks populated."])

# Custom sorting function for sorting by name
func sort_by_name(a, b):
	return a.name > b.name

# Function to get the next attack in the queue
func get_next_attack():
	#print("get_next_attack() called. Let's just check this node and its child nodes")
	
	#Helpers.print_all_children_check_in_tree(self)
	
	if attack_animations.size() <= 0:
		Debug.msg(Debug.ANIMATION, ["Tiried to attack but anims array not populated."])
		#push_warning("Tried to attack but attack anims array not populated yet.")
		populate_attacks()

	if attack_animations.size() <= 0:
		Debug.msg(Debug.ANIMATION, ["Could not find any attacks to attack with honestly"])
		return null
	
	if current_index >= attack_animations.size():
		# Reset queue if we've gone over the size
		current_index = 0
		reset_queue()

	# Retrieve the next attack
	var next_attack = attack_animations[current_index]
	current_index += 1

	#print("attack getter, attack in tree? ", next_attack.is_inside_tree())

	last_consumed_time = Time.get_ticks_msec()
	Debug.msg(Debug.ANIMATION, ["next attack is ", next_attack])
	return next_attack

# Function to reset the queue to its original state
func reset_queue():
	current_index = 0
	last_consumed_time = Time.get_ticks_msec()

# Function to check for timeout
func _process(_delta):
	if Time.get_ticks_msec() - last_consumed_time >= reset_time * 1000:
		reset_queue()
