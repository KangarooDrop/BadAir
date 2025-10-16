extends RigidBody3D
class_name ThrownItem

@export var spawn_item : String = ""

@onready var sprite : Sprite3D = $Sprite3D
@onready var light : OmniLight3D = $OmniLight3D

var item : Item = null

const VEL_TO_SOUND : float = 1.0/30.0

func _ready() -> void:
	add_to_group(Util.GROUP_PICKUP)
	var itemToSpawn = null
	if spawn_item.to_lower() == "rock":
		itemToSpawn = Util.itemRock.duplicate()
	if spawn_item.to_lower() == "key":
		itemToSpawn = Util.itemKey.duplicate()
	if itemToSpawn != null:
		setItem(itemToSpawn)

func setItem(newItem : Item) -> void:
	if item != null:
		item.on_expire.disconnect(self.onExpire)
	item = newItem
	item.on_expire.connect(self.onExpire)
	
	if item.id == Util.itemRat.id:
		item.currentLife = item.lifetime
	light.visible = newItem.isLit
	sprite.texture = newItem.groundTexture
	(sprite.material_override as ShaderMaterial).set_shader_parameter("tex", sprite.texture)
	
	if newItem.isLit:
		light.light_energy = newItem.getLightEnergy()
		light.omni_range = newItem.lightRange
		light.light_color = newItem.lightColor

func _process(delta: float) -> void:
	item._process(delta)
	light.light_energy = item.getLightEnergy()

var lastVelocity : Vector3 = Vector3.ZERO
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	linear_damp = 0.0
	var newContactCount : int = state.get_contact_count()
	for i in range(newContactCount):
		var normal : Vector3 = state.get_contact_local_normal(i)
		if normal.dot(Vector3.UP) > 0.5:
			linear_damp = 3.0
	
	if(lastVelocity.length() - linear_velocity.length()) > 1.0:
		var asp : AudioStreamPlayer3D = SoundManager.playStreamAtPoint(item.landingSound, global_position)
		if asp != null:
			asp.volume_db = SoundManager.getAudjustedDB(lastVelocity.length() * VEL_TO_SOUND)
	lastVelocity = linear_velocity

func onExpire():
	if item.id == Util.itemMushroom.id:
		die()
	elif item.id == Util.itemRat.id:
		item.currentLife = item.lifetime
		SoundManager.playRatSqueak(global_position)
		Util.getWorld().getLevel().createRat(global_position + Vector3.UP * 0.1, Vector3.UP * 4.0, item)
		queue_free()
		
func getBit(_damage) -> bool:
	return false
	#Util.getWorld().getLevel().createCorpse(global_position, linear_velocity, Rat.CORPSE_TEX)
	#die()

func die():
	item.on_death.emit()
	queue_free()
