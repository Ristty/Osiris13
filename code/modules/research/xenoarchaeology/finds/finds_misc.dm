//Talk crystal

/obj/item/weapon/talkingcrystal

	name = "Crystal"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "talk_crystal"
	//listening_to_players = 1
	//speaking_to_players = 1

/obj/item/weapon/talkingcrystal/New()
	src.talking_atom = new (src)
	if(prob(50))
		icon_state = "talk_crystal2"
	//START_PROCESSING(SSobj, src)


///obj/item/weapon/crystal/Destroy()
	//..()
	//STOP_PROCESSING(SSobj, src)