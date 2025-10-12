extends CharacterBody3D
class_name Rat

const HEALTH_MAX : float = 30.0
const HEALTH_REGEN : float = HEALTH_MAX/3.0
const SPEED : float = 2.5
const TRAC_RUN : float = 0.5
const TRAC_WANDER : float = 0.05
const JUMP_FORCE : float = 4.2
const DETECT_RANGE : float = 5.0
const KILL_PLANE : float = -300.0

var grav : float = ProjectSettings.get_setting("physics/3d/default_gravity")
var health : float = HEALTH_MAX
var item : Item
var wanderAngle : float = 0.0
var jumpingOffWall : bool = false

var onFloorLastFrame : bool = false

@onready var anim : AnimatedSprite3D = $AnimatedSprite3dShader

func _ready() -> void:
	if item == null:
		item = Util.itemRat.duplicate()
	item.currentLife = item.lifetime
	add_to_group(Util.GROUP_PICKUP)

func _physics_process(delta: float) -> void:
	if health <= 0.0:
		queue_free()
		return
	
	if poisonGasses.size() > 0:
		health -= Util.getGasStrengthToDec(currentPoisonStrength) * delta
	elif health < HEALTH_MAX:
		health = min(health + HEALTH_REGEN * delta, HEALTH_MAX)
	
	if not is_on_floor():
		velocity.y -= grav * delta
	
	var afraid : bool = false
	if is_on_floor() or jumpingOffWall:
		var threats : Array = get_tree().get_nodes_in_group("Player")
		var tDist : float = 0.0
		var runDir : Vector3 = Vector3.ZERO
		for other : Node3D in threats:
			var dp : Vector3 = global_position - other.global_position
			var dist : float = dp.length()
			if dist < DETECT_RANGE and (not afraid or tDist < dist):
				afraid = true
				tDist = dist
				runDir = Vector3(dp.x, 0.0, dp.z).normalized()
		if afraid:
			velocity.x = lerp(velocity.x, runDir.x * SPEED, TRAC_RUN)
			velocity.z = lerp(velocity.z, runDir.z * SPEED, TRAC_RUN)
			wanderAngle = Vector2(velocity.x, velocity.z).angle()
		else:
			wanderAngle += (randf()*2.0-1.0) * PI/8.0
			wanderAngle = fmod(wanderAngle + PI*2.0, PI*2.0)
			var wd2 : Vector2 = Vector2.RIGHT.rotated(wanderAngle)
			var wanderDir : Vector3 = Vector3(wd2.x, 0.0, wd2.y)
			velocity.x = lerp(velocity.x, wanderDir.x, TRAC_WANDER)
			velocity.z = lerp(velocity.z, wanderDir.z, TRAC_WANDER)
	
	playAnim()
	
	move_and_slide()
	
	if is_on_floor():
		jumpingOffWall = false
	if is_on_wall() and is_on_floor():
		if afraid:
			velocity.y = JUMP_FORCE
			jumpingOffWall = true
		else:
			wanderAngle += PI
	
	if not is_on_floor() and onFloorLastFrame:
		if afraid:
			velocity.y = JUMP_FORCE
		else:
			velocity = -velocity
			global_position += velocity * delta
			wanderAngle += PI
	onFloorLastFrame = is_on_floor()
	
	if position.y < KILL_PLANE:
		health = -999.0

func playAnim() -> void:
	var dirIndex : int = Util.getCameraRotIndex(Vector2(velocity.x, velocity.z))
	match dirIndex:
		0:
			anim.play("front")
		1:
			anim.play("left")
		2:
			anim.play("back")
		3:
			anim.play("right")

var poisonGasses : Array = []
var currentPoisonStrength : int = -1
func onEnterPoison(poisonGas) -> void:
	poisonGasses.append(poisonGas)
	if poisonGas.strength > currentPoisonStrength:
		currentPoisonStrength = poisonGas.strength
func onExitPoison(poisonGas) -> void:
	poisonGasses.erase(poisonGas)
	var newPoisonStrength : int = -1
	for pg in poisonGasses:
		if pg.strength > newPoisonStrength:
			newPoisonStrength = pg.strength
	currentPoisonStrength = newPoisonStrength
