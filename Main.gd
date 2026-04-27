extends Node


const television_b = '\nconst Television_B = preload("res://mods/TV_Party/Scenes/Television/Television_B_F.tscn")'


func _ready():
    var db_script = load("res://Scripts/Database.gd")
    var db_override_source = db_script.source_code
    db_override_source += television_b
    var db_override_script = GDScript.new()
    db_override_script.source_code = db_override_source
    db_override_script.reload()
    var db = get_node("/root/Database")
    db.set_script(db_override_script)
    Database.ExecuteUpdate(true)
    
    print("[TV Party] Television B added to master loot table")
    
    queue_free()
