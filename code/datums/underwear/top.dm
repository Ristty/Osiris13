/datum/category_item/underwear/top
	underwear_name = "bra"
	underwear_type = /obj/item/underwear/top
	underwear_gender = FEMALE

/datum/category_item/underwear/top/none
	name = "None"
	always_last = TRUE
	underwear_type = null
	underwear_gender = MALE

/datum/category_item/underwear/top/none/is_default(var/gender)
	return gender != FEMALE

/datum/category_item/underwear/top/bra_red
	name = "Bra, red"
	icon_state = "f1"

/datum/category_item/underwear/top/bra_white
	is_default = TRUE
	name = "Bra, white"
	icon_state = "f2"

/datum/category_item/underwear/top/bra_white/is_default(var/gender)
	return gender == FEMALE

/datum/category_item/underwear/top/bra_yellow
	name = "Bra, yellow"
	icon_state = "f3"

/datum/category_item/underwear/top/bra_blue
	name = "Bra, blue"
	icon_state = "f4"

/datum/category_item/underwear/top/bra_black
	name = "Bra, black"
	icon_state = "f5"

/datum/category_item/underwear/top/sports_bra_white
	name = "Sports bra, white"
	icon_state = "f8"