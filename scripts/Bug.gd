extends CharacterBody3D
class_name Bug

const CORPSE_TEX : Texture2D = preload("res://art/world/dead_bug.png")
const HEALTH_MAX : float = 30.0
const HEALTH_REGEN : float = HEALTH_MAX/3.0
const SPEED : float = 2.5
const TRAC_RUN : float = 0.5
const TRAC_WANDER : float = 0.05
const JUMP_FORCE : float = 4.2
const DETECT_RANGE : float = 10.0
const DAMAGE : float = 60.0
const KNOCKBACK : float = 1.75

var grav : float = ProjectSettings.get_setting("physics/3d/default_gravity")
var health : float = HEALTH_MAX
var item : Item
var wanderAngle : float = 0.0
var jumpingOffWall : bool = false

var onFloorLastFrame : bool = false

@onready var anim : AnimatedSprite3D = $AnimatedSprite3dShader

func _ready() -> void:
	add_to_group(Util.GROUP_BUGGIE)

func _physics_process(delta: float) -> void:
	if health <= 0.0:
		Util.getWorld().getLevel().createCorpse(global_position, velocity, CORPSE_TEX)
		die()
		return
	
	if poisonGasses.size() > 0:
		health -= Util.getGasStrengthToDec(currentPoisonStrength) * delta
	elif health < HEALTH_MAX:
		health = min(health + HEALTH_REGEN * delta, HEALTH_MAX)
	
	if not is_on_floor():
		velocity.y -= grav * delta
	
	var afraid : bool = false
	var attacking : bool = false
	if is_on_floor() or jumpingOffWall:
		var rats : Array 
		for rat in get_tree().get_nodes_in_group(Util.GROUP_RAT):
			rats.append(rat)
		for thrownItem in get_tree().get_nodes_in_group(Util.GROUP_PICKUP):
			if thrownItem.item.id == Util.itemRat.id:
				rats.append(thrownItem)
		var target
		var nearestDist : float = DETECT_RANGE * 2.0
		for other in rats:
			var dp : Vector3 = global_position - other.global_position
			var dist : float = dp.length()
			if dist < nearestDist:
				target = other
				nearestDist = dist
		if target == null:
			for p in get_tree().get_nodes_in_group("Player"):
				if (global_position - p.global_position).length() < DETECT_RANGE:
					target = p
		
		
		
		var tDist : float = 0.0
		var runDir : Vector3 = Vector3.ZERO
		
		if target != null and (global_position - target.global_position).length() < 1.0:
			if target.has_method("getBit"):
				if target.getBit(DAMAGE):
					var v2 = Vector2.UP.rotated(wanderAngle + 3.0*PI/2)
					var v : Vector3 = Vector3(v2.x, 0.25, v2.y).normalized() * KNOCKBACK
					velocity = v
					if "velocity" in target:
						target.velocity = Vector3(-v.x, v.y*2.0, -v.z)*3.0
						target.position.y += 0.1
				
			attacking = true
		if target != null and (not afraid or tDist < nearestDist):
			afraid = true
			tDist = nearestDist
			var dp : Vector3 = global_position - target.global_position
			runDir = Vector3(-dp.x, 0.0, -dp.z).normalized()
			
		if afraid and not attacking:
			velocity.x = lerp(velocity.x, runDir.x * SPEED, TRAC_RUN)
			velocity.z = lerp(velocity.z, runDir.z * SPEED, TRAC_RUN)
			wanderAngle = Vector2(velocity.x, velocity.z).angle()
		elif not attacking:
			wanderAngle += (randf()*2.0-1.0) * PI/8.0
			wanderAngle = fmod(wanderAngle + PI*2.0, PI*2.0)
			var wd2 : Vector2 = Vector2.RIGHT.rotated(wanderAngle)
			var wanderDir : Vector3 = Vector3(wd2.x, 0.0, wd2.y)
			velocity.x = lerp(velocity.x, wanderDir.x, TRAC_WANDER)
			velocity.z = lerp(velocity.z, wanderDir.z, TRAC_WANDER)
		else:
			attacking = false
	
	var thrownItems: Array = get_tree().get_nodes_in_group(Util.GROUP_PICKUP)
	for thing in thrownItems:
		#add rock into if statment for hurting bug
		if thing.item.canDamage:
			var dp : Vector3 = global_position - thing.global_position
			var dist = dp.length()
			if dist < 1.0 and thing.linear_velocity.length() > 0.5:
				health = -999
				
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

func die():
	#item.on_death.emit()
	queue_free()
