extends Widget

var units = "%"
var current_value

@onready var percentage_label : Label = get_node("PercentageLabel")

# Called when the node enters the scene tree for the first time.
func _ready():
	if label == null:
		label = get_node("Label")

	if option_node == null:
		option_node = get_node("HSlider")

	option_node.value_changed.connect(listen)

func listen(value):
	widget_value_changed.emit(value)
	current_value = value
	_set_display_text()
	Debug.msg(Debug.SETTINGS_UI, ["Changed UI value to " + str(value)])

func set_value(the_value):
	super(the_value)
	current_value = the_value
	_set_display_text()
	option_node.set_value(the_value)

func _set_display_text():
	percentage_label.text = str(current_value) + units

func set_min_max(_min, _max):
	option_node.min_value = _min
	option_node.max_value = _max

func set_extra_data(data : Dictionary):
	units = data.units
	self.set_min_max(data.min_value, data.max_value)
	_set_display_text()