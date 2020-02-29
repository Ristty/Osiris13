/datum/organ_description
	var/name = "limb"
	var/surgery_name
	var/organ_tag = "limb"
	var/body_part = null
	var/parent_organ = null
	var/default_type = /obj/item/organ/external

	var/max_damage = 0
	var/min_broken_damage = 30
	var/dislocated = 0
	var/vital = FALSE
	var/cannot_amputate = FALSE

	var/w_class = ITEM_SIZE_NORMAL
	var/cavity_max_w_class = ITEM_SIZE_TINY

	var/amputation_point = "spine"
	var/joint = "neck"
	var/encased
	var/cavity_name = "cavity"

	var/icon_position = null
	var/functions = NONE
	var/list/drop_on_remove = null

/datum/organ_description/proc/create_organ(var/mob/living/carbon/human/H)
	return new default_type(H,src)

/datum/organ_description/chest
	name = "upper body"
	surgery_name = "torso"
	organ_tag = BP_CHEST
	body_part = UPPER_TORSO
	default_type = /obj/item/organ/external/chest

	max_damage = 100
	min_broken_damage = 60
	dislocated = -1
	vital = TRUE
	cannot_amputate = TRUE

	w_class = ITEM_SIZE_HUGE
	cavity_max_w_class = ITEM_SIZE_NORMAL

	joint = "neck"
	amputation_point = "spine"
	encased = "ribcage"
	cavity_name = "thoracic cavity"

/datum/organ_description/groin
	name = "lower body"
	surgery_name = "lower abdomen"
	organ_tag = BP_GROIN
	body_part = LOWER_TORSO
	parent_organ = BP_CHEST
	default_type = /obj/item/organ/external/groin

	max_damage = 100
	min_broken_damage = 60
	dislocated = -1

	w_class = ITEM_SIZE_BULKY
	cavity_max_w_class = ITEM_SIZE_SMALL

	joint = "hip"
	amputation_point = "lumbar"
	cavity_name = "abdominal cavity"

/datum/organ_description/head
	name = "head"
	surgery_name = "head" // Prevents "Unknown's Unkonwn's head" from popping up if the head was amputated and then reattached
	organ_tag = BP_HEAD
	body_part = HEAD
	parent_organ = BP_CHEST
	default_type = /obj/item/organ/external/head

	max_damage = 75
	min_broken_damage = 60
	vital = TRUE

	w_class = ITEM_SIZE_NORMAL

	joint = "jaw"
	amputation_point = "neck"
	encased = "skull"
	cavity_name = "cranial cavity"

	drop_on_remove = list(slot_glasses, slot_head, slot_l_ear, slot_r_ear, slot_wear_mask)
	functions = BODYPART_REAGENT_INTAKE | BODYPART_GAS_INTAKE

/datum/organ_description/arm
	parent_organ = BP_CHEST

	w_class = ITEM_SIZE_NORMAL

	max_damage = 50
	min_broken_damage = 50

	functions = BODYPART_GRASP

/datum/organ_description/arm/left
	name = "left arm"
	organ_tag = BP_L_ARM
	body_part = ARM_LEFT

	joint = "left elbow"
	amputation_point = "left shoulder"

/datum/organ_description/arm/right
	name = "right arm"
	organ_tag = BP_R_ARM
	body_part = ARM_RIGHT

	joint = "right elbow"
	amputation_point = "right shoulder"

/datum/organ_description/leg
	parent_organ = BP_GROIN

	w_class = ITEM_SIZE_NORMAL

	max_damage = 60
	min_broken_damage = 50

	functions = BODYPART_STAND

/datum/organ_description/leg/left
	name = "left leg"
	organ_tag = BP_L_LEG
	body_part = LEG_LEFT
	icon_position = LEFT

	joint = "left knee"
	amputation_point = "left hip"

/datum/organ_description/leg/right
	name = "right leg"
	organ_tag = BP_R_LEG
	body_part = LEG_RIGHT
	icon_position = RIGHT

	joint = "right knee"
	amputation_point = "right hip"

////SLIME////
/datum/organ_description/chest/slime
	name = "upper body"
	default_type = /obj/item/organ/external/unbreakable

/datum/organ_description/groin/slime
	name = "fork"
	default_type = /obj/item/organ/external/unbreakable

/datum/organ_description/head/slime
	default_type = /obj/item/organ/external/unbreakable

/datum/organ_description/arm/left/slime
	default_type = /obj/item/organ/external/unbreakable

/datum/organ_description/arm/right/slime
	default_type = /obj/item/organ/external/unbreakable

/datum/organ_description/leg/left/slime
	default_type = /obj/item/organ/external/unbreakable

/datum/organ_description/leg/right/slime
	default_type = /obj/item/organ/external/unbreakable