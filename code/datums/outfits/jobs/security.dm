/decl/hierarchy/outfit/job/security
	hierarchy_type = /decl/hierarchy/outfit/job/security
	l_ear = /obj/item/device/radio/headset/headset_sec
	gloves = /obj/item/clothing/gloves/security/ironhammer
	shoes = /obj/item/clothing/shoes/jackboots/ironhammer
	id_type = /obj/item/weapon/card/id/sec
	pda_type = /obj/item/modular_computer/pda/security
	backpack_contents = list(/obj/item/weapon/handcuffs = 1)

/decl/hierarchy/outfit/job/security/New()
	..()
	BACKPACK_OVERRIDE_SECURITY

/decl/hierarchy/outfit/job/security/ihc
	name = OUTFIT_JOB_NAME("Ironhammer Commander")
	l_ear = /obj/item/device/radio/headset/heads/hos
	uniform = /obj/item/clothing/under/rank/ih_commander
	l_pocket = /obj/item/device/flash
	id_type = /obj/item/weapon/card/id/hos
	belt = /obj/item/weapon/gun/energy/gun/martin
	head = /obj/item/clothing/head/HoS
	pda_type = /obj/item/modular_computer/pda/heads/hos
	backpack_contents = list(/obj/item/weapon/handcuffs = 1,/obj/item/device/lighting/toggleable/flashlight/seclite = 1, /obj/item/weapon/cell/small/high = 2)

/decl/hierarchy/outfit/job/security/gunserg
	name = OUTFIT_JOB_NAME("Ironhammer Gunnery Sergeant")
	uniform = /obj/item/clothing/under/rank/warden
	head = /obj/item/clothing/head/beret/sec/navy/warden
	belt = /obj/item/weapon/gun/energy/gun/martin
	backpack_contents = list(/obj/item/weapon/cell/small/high = 1)

/decl/hierarchy/outfit/job/security/inspector
	name = OUTFIT_JOB_NAME("Ironhammer Inspector")
	uniform = /obj/item/clothing/under/rank/inspector
	shoes = /obj/item/clothing/shoes/reinforced/ironhammer
	belt = /obj/item/weapon/gun/energy/gun/martin
	r_hand = /obj/item/weapon/storage/briefcase/crimekit
	id_type = /obj/item/weapon/card/id/det
	pda_type = /obj/item/modular_computer/pda/forensics
	backpack_contents = list(/obj/item/weapon/handcuffs = 1, /obj/item/device/lighting/toggleable/flashlight/seclite = 1, /obj/item/weapon/cell/small/high = 2)

/decl/hierarchy/outfit/job/security/detective/New()
	..()
	backpack_overrides.Cut()

/decl/hierarchy/outfit/job/security/medspec
	name = OUTFIT_JOB_NAME("Ironhammer Medical Specialist")
	id_type = /obj/item/weapon/card/id/medcpec
	uniform = /obj/item/clothing/under/rank/medspec
	pda_type = /obj/item/modular_computer/pda/forensics
	belt = /obj/item/weapon/storage/belt/medical
	backpack_contents = list(/obj/item/weapon/gun/energy/gun/martin = 1, /obj/item/weapon/cell/small/high = 1)

/decl/hierarchy/outfit/job/security/ihoper
	name = OUTFIT_JOB_NAME("Ironhammer Operative")
	r_pocket = /obj/item/weapon/handcuffs
	l_pocket = /obj/item/device/flash
	uniform = /obj/item/clothing/under/rank/security
	belt = /obj/item/weapon/gun/energy/gun/martin
	backpack_contents = list(/obj/item/weapon/cell/small/high = 2)
