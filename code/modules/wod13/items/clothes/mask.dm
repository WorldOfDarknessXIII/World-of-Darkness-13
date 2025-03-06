/obj/item/clothing/mask/vampire
	name = "respirator"
	desc = "A face-covering mask that can be connected to an air supply. While good for concealing your identity, it isn't good for blocking gas flow." //More accurate
	icon_state = "respirator"
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	inhand_icon_state = ""
	w_class = WEIGHT_CLASS_NORMAL
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	flags_cover = MASKCOVERSMOUTH | PEPPERPROOF
	resistance_flags = NONE
	body_worn = TRUE

/obj/item/clothing/mask/vampire/balaclava
	name = "balaclava"
	desc = "LOADSAMONEY"
	icon_state = "balaclava"
	inhand_icon_state = "balaclava"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/mask/pentex/pentex_balaclava
	name = "Thick balaclava"
	desc = "A black balaclava. This one is particularly thick."
	icon_state = "pentex_balaclava"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/mask/vampire/tragedy
	name = "tragedy"
	desc = "The Greek Tragedy mask."
	icon_state = "tragedy"
	inhand_icon_state = "tragedy"
	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/mask/vampire/comedy
	name = "comedy"
	desc = "The Greek Comedy mask."
	icon_state = "comedy"
	inhand_icon_state = "comedy"
	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/mask/vampire/shemagh
	name = "shemagh"
	desc = "Covers your face pretty well."
	icon_state = "shemagh"
	inhand_icon_state = "shemagh"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/mask/vampire/venetian_mask
	name = "Venetian mask"
	desc = "You could wear this to a real masquerade."
	icon_state = "venetian_mask"
	inhand_icon_state = "venetian_mask"
	flags_inv = HIDEFACE | HIDEFACIALHAIR | HIDESNOUT
	flags_cover = MASKCOVERSMOUTH
	visor_flags_inv = HIDEFACE | HIDEFACIALHAIR | HIDESNOUT

/obj/item/clothing/mask/vampire/venetian_mask/fancy
	name = "fancy Venetian mask"
	desc = "Weird rich people definitely wear this kind of stuff."
	icon_state = "venetian_mask_fancy"
	inhand_icon_state = "venetian_mask_fancy"

/obj/item/clothing/mask/vampire/venetian_mask/jester
	name = "jester mask"
	desc = "They will all be amused, every last one of them."
	icon_state = "venetian_mask_jester"
	inhand_icon_state = "venetian_mask_jester"

/obj/item/clothing/mask/vampire/venetian_mask/scary
	name = "bloody mask"
	desc = "With this, you'll look ready to butcher someone."
	icon_state = "venetian_mask_scary"
	inhand_icon_state = "venetian_mask_scary"
	flags_inv = HIDEFACE
	flags_cover = NONE
	visor_flags_inv = HIDEFACE

