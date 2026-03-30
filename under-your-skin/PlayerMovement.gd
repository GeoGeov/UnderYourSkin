extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var fling_power: float = 60.0
@export var max_drag_distance: float = 100.0
@export var momentum_conserve: float = 0.2 #Howmuch Velocity to be conserved between jumps

#Drag Vars
var is_dragging: bool = false
var drag_start: Vector2
var current_friction: float = 2.0

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		#LeftMouse Events
		if event.button_index == MOUSE_BUTTON_LEFT:	

			#On Press Check if over pause
			if event.pressed:
				drag_start = get_viewport().get_mouse_position()
				is_dragging = true
			else:
				var drag_end = get_viewport().get_mouse_position()
				var drag_vec = (drag_end - drag_start).limit_length(max_drag_distance) * -1
				velocity = (velocity*momentum_conserve) - Vector3(drag_vec.normalized().x, drag_vec.normalized().y, 0 ) * drag_vec.length() / 10.0 * fling_power
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
