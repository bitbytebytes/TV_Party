extends Node3D


var gameData = preload("res://Resources/GameData.tres")
var audioLibrary = preload("res://Resources/AudioLibrary.tres")
var audioInstance2D = preload("res://Resources/AudioInstance2D.tscn")


var active = false
@export var furniture: Furniture
@export var mesh: MeshInstance3D
@export var defaultMaterial: Material
@export var videoMaterial: Material
@export var noVideoMaterial: Material
@export var light: SpotLight3D
@export var audio: AudioStreamPlayer3D

@onready var sub_viewport: SubViewport = $SubViewport
@onready var tv_screen: VideoStreamPlayer = %TVScreen
var video_path = "user://tv_party/tv_party.ogv"
var video_loaded: bool = false

func _ready() -> void :
    Deactivate()

func _physics_process(_delta):
    if Engine.get_physics_frames() % 10 == 0:
        if active && furniture.isMoving:
            MoveReset()

func UpdateTooltip():
    if active:
        gameData.tooltip = "TV [Turn Off]"
    else:
        gameData.tooltip = "TV [Turn On]"

func Interact():
    active = !active
    if active: Activate()
    else: Deactivate()
    PlayToggle()

func Activate():
    if ResourceLoader.exists(video_path):
        var ogv_stream = VideoStreamTheora.new()
        ogv_stream.set_file(video_path)
        video_loaded = true
        tv_screen.stream = ogv_stream
        tv_screen.play()
        mesh.set_surface_override_material(1, videoMaterial)
    else:
        video_loaded = false
        print("[TV Party] failed to load " + video_path)
        audio.play()
        mesh.set_surface_override_material(1, noVideoMaterial)
    light.spot_range = 1.0
    light.show()

func Deactivate():
    if video_loaded:
        tv_screen.stop()
        tv_screen.stream = null
        video_loaded = false
    else:
        audio.stop()
    mesh.set_surface_override_material(1, defaultMaterial)
    light.spot_range = 0.0
    light.hide()

func MoveReset():
    if video_loaded:
        tv_screen.stop()
    else:
        audio.stop()
    mesh.set_surface_override_material(1, furniture.furnitureMaterial)
    light.spot_range = 0.0
    light.hide()
    active = false

func PlayToggle():
    var toggle = audioInstance2D.instantiate()
    add_child(toggle)
    toggle.PlayInstance(audioLibrary.UICasettePlay)
