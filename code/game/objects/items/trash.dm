//Items labled as 'trash' for the trash bag.
//TODO: Make this an item var or something...

/obj/item/trash
	name = "trash"
	desc = "This is rubbish."
	icon = 'icons/obj/trash.dmi'
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_PLASTIC = 1)

/obj/item/trash/attack(mob/M, mob/living/user)
	return


/obj/item/trash/raisins
	name = "\improper 4no raisins"
	icon_state= "4no_raisins"

/obj/item/trash/candy
	name = "candy"
	icon_state = "candy"

/obj/item/trash/cheesie
	name = "\improper Cheesie Honkers"
	icon_state = "cheesie_honkers"

/obj/item/trash/chips
	name = "chips"
	icon_state = "chips"

/obj/item/trash/popcorn
	name = "popcorn"
	icon_state = "popcorn"

/obj/item/trash/sosjerky
	name = "Scaredy's Private Reserve Beef Jerky"
	icon_state = "sosjerky"

/obj/item/trash/syndi_cakes
	name = "syndi cakes"
	icon_state = "syndi_cakes"

/obj/item/trash/waffles
	name = "waffles"
	icon_state = "waffles"

/obj/item/trash/plate
	name = "plate"
	icon_state = "plate"
	matter = list(MATERIAL_GLASS = 1)

/obj/item/trash/snack_bowl
	name = "snack bowl"
	icon_state	= "snack_bowl"
	matter = list(MATERIAL_GLASS = 1)

/obj/item/trash/pistachios
	name = "pistachios pack"
	icon_state = "pistachios_pack"

/obj/item/trash/semki
	name = "semki pack"
	icon_state = "semki_pack"

/obj/item/trash/tray
	name = "tray"
	icon_state = "tray"
	matter = list(MATERIAL_STEEL = 1)

/obj/item/trash/candle
	name = "candle"
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle4"

/obj/item/trash/liquidfood
	name = "\improper \"LiquidFood\" ration"
	icon_state = "liquidfood"

/obj/item/trash/tastybread
	name = "bread tube"
	icon_state = "tastybread"