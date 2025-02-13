/obj/item/charcoal_stick
    name = "charcoal stick"
    desc = "A piece of burnt charcoal."
    icon = 'icons/obj/crayons.dmi'
    icon_state = "crayonblack"
    w_class = WEIGHT_CLASS_SMALL
    var/list/rituals = list()

/obj/item/charcoal_stick/Initialize()
    . = ..()
    // Populate the rituals list with glyph objects
    for(var/i in subtypesof(/obj/effect/decal/garou_glyph))
        if(i)
            var/obj/effect/decal/garou_glyph/G = new i(src)
            rituals |= list(G)

/obj/item/charcoal_stick/afterattack(atom/target, mob/living/carbon/user, proximity)
    . = ..()
    var/site = get_turf(target)
    if(!proximity || !isgarou(user))
        return
    if(rituals.len == 0)
        user << "There are no glyphs available."
        return

    var/list/glyph_names = list()
    for(var/obj/effect/decal/garou_glyph/glyph in rituals)
        if(isgarou(user))
            glyph_names += glyph.garou_name
        else
            glyph_names += glyph.name

    var/choice = input(user, "Select a glyph to draw.", "Glyph Selection") in glyph_names
    if(choice)
        var/obj/effect/decal/garou_glyph/drawn_glyph
        for(var/obj/effect/decal/garou_glyph/glyph in rituals)
            if((isgarou(user) && glyph.garou_name == choice) || (!isgarou(user) && glyph.name == choice))
                drawn_glyph = glyph
                break

        if(drawn_glyph)
            if(do_after(user, 5, user))
                if(get_dist(user, site) <= 1)
                    new drawn_glyph.type(site)
                    user.visible_message("<span class='notice'>[user] starts drawing a glyph onto [site]...</span>")
                else
                    user.visible_message("<span class='notice'>You fail to draw a glyph.</span>")
    return

/obj/effect/decal/garou_glyph
    name = "Odd Glyph"
    desc = "An odd collection of symbols drawn in what seems to be charcoal."
    var/garou_name = "basic glyph"
    var/garou_desc = "a basic glyph with no meaning." // This is shown to werewolves who examine the glyph in order to determine its true meaning.
    anchored = TRUE
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "garou"
    color = "#000000"
    resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
    layer = SIGIL_LAYER

/obj/effect/decal/garou_glyph/examine(mob/user)
    . = ..()
    if(isgarou(user) || iswerewolf(user)) // If they're a werewolf, show them the true meaning of the glyph.
        . += "<b>Name:</b> [garou_name]\n" + \
        "<b>Description:</b> [garou_desc]\n"

/obj/effect/decal/garou_glyph/wyrm
    name = "Creepy Glyph"
    garou_name = "Wyrm Glyph"
    garou_desc = "A glyph that represents the Wyrm, a force of corruption and destruction."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "wyrm"
    color = "#000000"

/obj/effect/decal/garou_glyph/vampire
    name = "Weird Glyph"
    garou_name = "Vampire Glyph"
    garou_desc = "A glyph that represents the Kindred, leeches of the Weaver and Wyrm."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "vampire"
    color = "#000000"

/obj/effect/decal/garou_glyph/kinfolk
    name = "Uncanny Glyph"
    garou_name = "Kinfolk Glyph"
    garou_desc = "A glyph that represents the Kinfolk, the human relatives of the Garou."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "kinfolk"
    color = "#000000"

/obj/effect/decal/garou_glyph/dance
    name = "Funky Glyph"
    garou_name = "Dancing Glyph"
    garou_desc = "A glyph that represents the spiritual dancing of the Garou."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "dance"
    color = "#000000"

/obj/effect/decal/garou_glyph/caern
    name = "Eerie Glyph"
    garou_name = "Caern Glyph"
    garou_desc = "A glyph that represents the Caern, a sacred location that naturally flows with spiritual energy."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "caern"
    color = "#000000"

/obj/effect/decal/garou_glyph/danger
    name = "Peculiar Glyph"
    garou_name = "Danger Glyph"
    garou_desc = "A glyph that represents danger! Proceed with caution."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "danger"
    color = "#000000"

/obj/effect/decal/garou_glyph/garou
    name = "Freakish Glyph"
    garou_name = "Garou Glyph"
    garou_desc = "A glyph that represents the Garou, the warriors of Gaia."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "garou"
    color = "#000000"

/obj/effect/decal/garou_glyph/conceal
    name = "Mysterious Glyph"
    garou_name = "Conceal Glyph"
    garou_desc = "A glyph that represents the obfuscation of something. What may be hidden from you?"
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "conceal"
    color = "#000000"

/obj/effect/decal/garou_glyph/hive
    name = "Outlandish Glyph"
    garou_name = "Hive Glyph"
    garou_desc = "A glyph that represents a Hive, the foul home of a Black Spiral Dancer pack."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "hive"
    color = "#000000"

/obj/effect/decal/garou_glyph/howl
    name = "Unusual Glyph"
    garou_name = "Howling Glyph"
    garou_desc = "A glyph that represents the natural song of the Garou, the howl."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "howl"
    color = "#000000"

/obj/effect/decal/garou_glyph/remembrance
    name = "Morose Glyph"
    garou_name = "Remembrance Glyph"
    garou_desc = "A glyph that represents the mourning and remembrance of the fallen."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "remembrance"
    color = "#000000"

/obj/effect/decal/garou_glyph/watch
    name = "Odd Glyph"
    garou_name = "Watch Glyph"
    garou_desc = "A glyph that marks something as in need of monitoring"
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "watch"
    color = "#000000"

/obj/effect/decal/garou_glyph/toxic
    name = "Foul Glyph"
    garou_name = "Toxic Glyph"
    garou_desc = "A glyph that represents toxicity, the material corruption of the Wyrm on the Earth."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "toxic"
    color = "#000000"

/obj/effect/decal/garou_glyph/dancers
    name = "Alien Glyph"
    garou_name = "Black Spiral Dancer Glyph"
    garou_desc = "A glyph that represents the tribe of the Black Spiral Dancers."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "black_spiral_dancers"
    color = "#000000"

/obj/effect/decal/garou_glyph/glasswalkers
    name = "Quirky Glyph"
    garou_name = "Glasswalkers Glyph"
    garou_desc = "A glyph that represents the Glasswalkers tribe."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "glasswalkers"
    color = "#000000"

/obj/effect/decal/garou_glyph/wendigo
    name = "Abnormal Glyph"
    garou_name = "Younger Brother Glyph"
    garou_desc = "A glyph that represents the Wendigo tribe."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "younger_brother"
    color = "#000000"

/obj/effect/decal/garou_glyph/war_against_wyrm
    name = "Terrifying Glyph"
    garou_name = "War Against Wyrm Glyph"
    garou_desc = "A glyph that represents the apocalyptic war of the Garou against the Wyrm."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "war_against_wyrm	"
    color = "#000000"
