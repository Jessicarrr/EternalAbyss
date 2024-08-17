extends ColorRect

var intensity_offsets = {
	"permanent_effect": 0.0,
	"gameplay_effect": 0.0,
	"gameplay_intensity_option_mult": 0.99,
}

var maximum_effect = 1.0

func calculate_grain_intensity():
	var total_intensity = intensity_offsets.permanent_effect + intensity_offsets.gameplay_effect
	self.material.set_shader_parameter("grain_amount", total_intensity)

func _on_film_grain_toggled(option_value):
	self.visible = option_value

func _on_permanent_intensity_changed(option_value):
	var intensity = float(option_value) / 1000 / 2
	intensity_offsets.permanent_effect = intensity

	calculate_grain_intensity()

	# option value between 0 and 100

func _on_gameplay_intensity_changed(option_value):
	# 0 to 1 to multiply it nicely
	intensity_offsets.gameplay_intensity_option_mult = option_value / 100
	calculate_grain_intensity()

# Called when the node enters the scene tree for the first time.
func _ready():
	var film_grain = Game.settings.graphics.film_grain
	var film_grain_intensity = Game.settings.graphics.film_grain_intensity
	var film_grain_gameplay_intensity = Game.settings.graphics.film_grain_gameplay_intensity

	_on_film_grain_toggled(film_grain.get_value())
	_on_permanent_intensity_changed(film_grain_intensity.get_value())
	_on_gameplay_intensity_changed(film_grain_gameplay_intensity.get_value())

	film_grain.setting_changed.connect(_on_film_grain_toggled)
	film_grain_intensity.setting_changed.connect(_on_permanent_intensity_changed)
	film_grain_gameplay_intensity.setting_changed.connect(_on_gameplay_intensity_changed)
