extends Widget

# Called when the node enters the scene tree for the first time.
func _ready():
	if label == null:
		label = get_node("Label")

	if option_node == null:
		option_node = get_node("OptionButton")

	option_node.item_selected.connect(listen)

func listen(index):
	var text = option_node.get_item_text(index)
	widget_value_changed.emit(text)
	Debug.msg(Debug.SETTINGS_UI, ["Changed UI widget value to " + text])


func set_value(the_value):
	super(the_value)
	for i in range(0, option_node.item_count):
		var text = option_node.get_item_text(i)
		if text == the_value:
			option_node.select(i)

	option_node.select(0)

func set_multi_choice_options(_opt_array):
	option_node.clear()

	for option in _opt_array:
		option_node.add_item(option)

func set_extra_data(data : Dictionary):
	self.set_multi_choice_options(data.options)
