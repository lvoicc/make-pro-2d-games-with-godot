extends "../Menu.gd"

export(PackedScene) var BuyMenu = preload("menus/BuySubMenu.tscn")
export(PackedScene) var SellMenu = preload("menus/SellSubMenu.tscn")

onready var buttons = $Column/Buttons
onready var submenu = $Column/Menu

onready var button_buy = $Column/Buttons/BuyButton
onready var button_sell = $Column/Buttons/SellButton

func _ready():
	hide()
	# To test from ShopMenu.tscn
#	var shop = load("res://core/shop/Shop.tscn").instance()
#	var player = load("res://actors/player/Player.tscn").instance()
#	open(shop, player)

func open(shop, buyer):
	get_tree().paused = true
	button_buy.connect("pressed", self, "open_submenu",
		[BuyMenu, shop, buyer, shop.inventory])
	button_sell.connect("pressed", self, "open_submenu",
		[SellMenu, shop, buyer, buyer.get_node("Inventory")])
	buttons.get_child(0).grab_focus()
	.open()

func close():
	get_tree().paused = false
	button_buy.disconnect('pressed', self, 'open_submenu')
	button_sell.disconnect('pressed', self, 'open_submenu')
	.close()

func open_submenu(Menu, shop, buyer, inventory):
	var pressed_button = get_focus_owner()
	
	var active_menu = Menu.instance()
	submenu.add_child(active_menu)
	active_menu.initialize(shop, buyer, inventory.get_items())
	set_process_input(false)
	active_menu.open()
	yield(active_menu, "closed")
	set_process_input(true)
	pressed_button.grab_focus()

func _on_QuitButton_pressed():
	close()
