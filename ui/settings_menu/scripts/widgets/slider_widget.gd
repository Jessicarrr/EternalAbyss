extends Widget

var units = "%"

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
	percentage_label.text = str(value) + units
	Debug.msg(Debug.SETTINGS_UI, ["Changed UI value to " + str(value)])

func set_value(the_value):
	super(the_value)
	percentage_label.text = str(the_value) + units
	option_node.set_value(the_value)
