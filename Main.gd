extends Node

const tv_path = "res://mods/TV_Party/Scenes/Television/Television_B_F"
const task_path = "res://mods/TV_Party/Tasks/11_TV_Party.tres"

var _lib = null

func _ready():
    
    if Engine.has_meta("RTVModLib"):
        var lib = Engine.get_meta("RTVModLib")
        if lib._is_ready():
            _on_lib_ready()
        else:
            lib.frameworks_ready.connect(_on_lib_ready)
    

func _on_lib_ready():
    _lib = Engine.get_meta("RTVModLib")
    _register_TV()


func _register_TV():
    var item_data = ResourceLoader.load(tv_path + ".tres", "", ResourceLoader.CACHE_MODE_REUSE)
    if not item_data:
        push_warning("[TV Party] failed to load " + tv_path + ".tres")
        return
        
    if not _lib.register(_lib.Registry.ITEMS, "Television_B", item_data):
        push_warning("[TV Party] Failed to register " + tv_path + ".tres")
        return
    #if not _lib.register(_lib.Registry.LOOT, "Television_B", { "item": item_data, "table":"LT_Master" }):
        #push_warning("[TV Party] Failed to add Television B to master loot table")
        #return
    print("[TV Party] Television B item registered")
    
    if not _lib.register(_lib.Registry.SCENES, "Television_B", preload(tv_path + ".tscn")):
        push_warning("[TV Party] Failed to register " + tv_path + ".tscn")
        return
    print("[TV Party] Television B scene registered")
    
    var task_data = ResourceLoader.load(task_path, "", ResourceLoader.CACHE_MODE_REUSE)
    if not task_data:
        push_warning("[TV Party] failed to load " + task_path)
        return
        
    if not _lib.register(_lib.Registry.TRADER_TASKS, "11_TV_Party", { "task": task_data, "trader": "Generalist" }):
        push_warning("[TV Party] Failed to register " + task_path)
        return
    print("[TV Party] TV Party task registered")
    
