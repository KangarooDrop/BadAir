extends RigidBody3D
class_name ThrownItem

@export var spawn_item : String = ""

@onready var sprite : Sprite3D = $Sprite3D
@onready var light : OmniLight3D = $OmniLight3D

var item : Item = null

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

func onExpire():
	if item.id == Util.itemMushroom.id:
		die()
	elif item.id == Util.itemRat.id:
		item.currentLife = item.lifetime
		Util.getWorld().getLevel().createRat(global_position + Vector3.UP * 0.1, Vector3.UP * 4.0, item)
		queue_free()
		
func getBit(_damage) -> bool:
	return false
	#Util.getWorld().getLevel().createCorpse(global_position, linear_velocity, Rat.CORPSE_TEX)
	#die()

func die():
	item.on_death.emit()
	queue_free()
