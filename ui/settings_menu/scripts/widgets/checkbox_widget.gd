extends Widget

# Called when the node enters the scene tree for the first time.
func _ready():
	if label == null:
		label = get_node("Label")

	if option_node == null:
		option_node = get_node("CheckBox")

	option_node.toggled.connect(listen)

func listen(toggled_on):
	widget_value_changed.emit(toggled_on)
	Debug.msg(Debug.SETTINGS_UI, ["Changed UI widget value to " + str(toggled_on)])

func set_value(the_value):
	super(the_value)
	option_node.set_pressed_no_signal(the_value)
