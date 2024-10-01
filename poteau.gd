extends StaticBody2D
@onready var poteau_anim: AnimatedSprite2D = $PoteauAnim
@onready var hole: Sprite2D = $Hole
@onready var barre_vertical_down: ColorRect = $BarreVerticalDown
@onready var barre_horizontalleft: ColorRect = $BarreHorizontalleft
@onready var barre_horizontal_right: ColorRect = $BarreHorizontalRight
@onready var barre_vertical_up: ColorRect = $BarreVerticalUp
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D



var start = 0.0
var end = 0.0
var holeDelete = 0.0
var go = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	poteau_anim.stop
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not go:
		start += delta
	if start > 3.0:
		startAnimPoteau()
	if go:
		holeDelete += delta
		if holeDelete > 2.0:
			hole.visible = false
			audio_stream_player_2d.play()
			holeDelete = 0.0
	if not poteau_anim.is_playing() and go:
		barre_vertical_down.visible=true
		barre_vertical_up.visible=true
		barre_horizontal_right.visible = true
		barre_horizontalleft.visible = true
		barre_vertical_down.size.y += 0.1
		barre_vertical_up.size.y += 1.5
		barre_horizontal_right.size.x += 1.5
		barre_horizontalleft.size.x += 0.1
		#poteau_anim.frame = 0
		end += delta
	if end > 1.5:
		queue_free()
	
	
	pass


func startAnimPoteau() -> void :
	poteau_anim.play()
	go = true
	start = 0.0
	pass
	
