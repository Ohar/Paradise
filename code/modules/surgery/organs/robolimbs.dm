GLOBAL_LIST_EMPTY(all_robolimbs)
GLOBAL_LIST_EMPTY(chargen_robolimbs)
GLOBAL_LIST_EMPTY(selectable_robolimbs)
GLOBAL_DATUM(basic_robolimb, /datum/robolimb)

/datum/robolimb
	var/company = "Без бренда"                                    // Shown when selecting the limb.
	var/desc = "Обычный небрендированный кибернетический протез." // Seen when examining a limb.
	var/icon = 'icons/mob/human_races/robotic.dmi'                // Icon base to draw from.
	var/unavailable_at_chargen                                    // If set, not available at chargen.
	var/selectable = 1									          // If set, is it available for selection on attack_self with a robo limb?
	var/is_monitor										          // If set, limb is a monitor and should be getting monitor styles.
	var/has_subtypes = 2								          // If null, object is a model. If 1, object is a brand (that serves as the default model) with child models. If 2, object is a brand that has no child models and thus also serves as the model..
	var/parts = list("chest", "groin", "head", "r_arm", "r_hand", "r_leg", "r_foot", "l_leg", "l_foot", "l_arm", "l_hand", "tail")	// Defines what parts said brand can replace on a body.

/datum/robolimb/bishop
	company = "«Бишоп Кибернетикс»" // Bishop Cybernetics
	desc = "Конечность выполнена в белом полимерном корпусе, с голубыми голографическими дисплеями."
	icon = 'icons/mob/human_races/cyberlimbs/bishop/bishop_main.dmi'
	has_subtypes = 1

/datum/robolimb/bishop/alt1
	company = "«Бишоп Кибернетикс», модель № 2" // Bishop Cybernetics alt.
	icon = 'icons/mob/human_races/cyberlimbs/bishop/bishop_alt1.dmi'
	parts = list("head")
	selectable = 0
	has_subtypes = null

/datum/robolimb/bishop/monitor
	company = "Монитор «Бишоп Кибернетикс»" // Bishop Cybernetics mtr.
	icon = 'icons/mob/human_races/cyberlimbs/bishop/bishop_monitor.dmi'
	parts = list("head")
	is_monitor = 1
	selectable = 0
	has_subtypes = null

/datum/robolimb/hesphiastos
	company = "«Гефиатос Индастриз»" // Hesphiastos Industries
	desc = "Конечность выполнена в чёрно-зелёном корпусе милитаристического стиля, с золотыми полосами."
	icon = 'icons/mob/human_races/cyberlimbs/hesphiastos/hesphiastos_main.dmi'
	has_subtypes = 1

/datum/robolimb/hesphiastos/alt1
	company = "«Гефиатос Индастриз», модель № 2" // Hesphiastos Industries alt.
	icon = 'icons/mob/human_races/cyberlimbs/hesphiastos/hesphiastos_alt1.dmi'
	parts = list("head")
	is_monitor = 1
	selectable = 0
	has_subtypes = null

/datum/robolimb/hesphiastos/monitor
	company = "Монитор «Гефиатос Индастриз»" // Hesphiastos Industries mtr.
	icon = 'icons/mob/human_races/cyberlimbs/hesphiastos/hesphiastos_monitor.dmi'
	parts = list("head")
	is_monitor = 1
	selectable = 0
	has_subtypes = null

/datum/robolimb/morpheus
	company = "«Морфей Кибернетикс»" // Morpheus Cyberkinetics
	desc = "Простая и функциональная конечность. Производитель не предпринял никаких усилий, чтобы сделать её похожей на человеческую."
	icon = 'icons/mob/human_races/cyberlimbs/morpheus/morpheus_main.dmi'
	unavailable_at_chargen = 1
	is_monitor = 1
	has_subtypes = 1

/datum/robolimb/morpheus/alt1
	company = "«Морфей Кибернетикс», модель № 2" // Morpheus Cyberkinetics alt.
	icon = 'icons/mob/human_races/cyberlimbs/morpheus/morpheus_alt1.dmi'
	parts = list("head")
	unavailable_at_chargen = null
	is_monitor = null
	selectable = 0
	has_subtypes = 2 //Edge case. We want to be able to pick this one, and if we had it left as null for has_subtypes
	                 // we'd be assuming it'll be chosen as a child model, and since the parent is unavailable
	                 // at chargen, we wouldn't be able to see it in the list anyway.
	                 // Now, we'll be able to select the Morpheus Ckt. Alt. head as a solo-model.

/datum/robolimb/wardtakahashi
	company = "«Страж Такахаши»" // Ward-Takahashi
	desc = "Конечность выполнена из гладких полимеров чёрно-белого цвета."
	icon = 'icons/mob/human_races/cyberlimbs/wardtakahashi/wardtakahashi_main.dmi'
	has_subtypes = 1

/datum/robolimb/wardtakahashi/alt1
	company = "«Страж Такахаши», модель № 2" // Ward-Takahashi alt.
	icon = 'icons/mob/human_races/cyberlimbs/wardtakahashi/wardtakahashi_alt1.dmi'
	parts = list("head")
	selectable = 0
	has_subtypes = null

/datum/robolimb/wardtakahashi/monitor
	company = "Монитор «Страж Такахаши»" // Ward-Takahashi mtr.
	icon = 'icons/mob/human_races/cyberlimbs/wardtakahashi/wardtakahashi_monitor.dmi'
	parts = list("head")
	is_monitor = 1
	selectable = 0
	has_subtypes = null

/datum/robolimb/xion
	company = "«Сиэнь Мануфэкчуринг Групп»" // Xion Manufacturing Group
	desc = "У этой конечности минималистичный корпус чёрно-красного цвета."
	icon = 'icons/mob/human_races/cyberlimbs/xion/xion_main.dmi'
	has_subtypes = 1

/datum/robolimb/xion/alt1
	company = "«Сиэнь Мануфэкчуринг Групп», модель № 2" // Xion Manufacturing Group alt.
	icon = 'icons/mob/human_races/cyberlimbs/xion/xion_alt1.dmi'
	parts = list("head")
	selectable = 0
	has_subtypes = null

/datum/robolimb/xion/monitor
	company = "Монитор «Сиэнь Мануфэкчуринг Групп»" // Xion Manufacturing Group mtr.
	icon = 'icons/mob/human_races/cyberlimbs/xion/xion_monitor.dmi'
	parts = list("head")
	is_monitor = 1
	selectable = 0
	has_subtypes = null

/datum/robolimb/zenghu
	company = "«Жэнг-Хо Фармацевтикс»" // Zeng-Hu Pharmaceuticals
	desc = "Конечность с резиновым покрытием телесного цвета. Швы довольно заметны."
	icon = 'icons/mob/human_races/cyberlimbs/zenghu/zenghu_main.dmi'
	has_subtypes = 2

/datum/robolimb/shellguard
	company = "Стандартная серия «Снаряды Шеллгардс»" // Shellguard Munitions Standard Series
	desc = "Конечность из прочной стали, покрашенная в цвета «Шеллгардс»."
	icon = 'icons/mob/human_races/cyberlimbs/shellguard/shellguard_main.dmi'
	has_subtypes = 1

/datum/robolimb/shellguard/alt1
	company = "Элитная серия «Снаряды Шеллгардс»" // Shellguard Munitions Elite Series
	icon = 'icons/mob/human_races/cyberlimbs/shellguard/shellguard_alt1.dmi'
	parts = list("head")
	selectable = 0
	has_subtypes = null

/datum/robolimb/shellguard/monitor
	company = "Линейка мониторов «Снаряды Шеллгардс»" // Shellguard Munitions Monitor Series
	icon = 'icons/mob/human_races/cyberlimbs/shellguard/shellguard_monitor.dmi'
	parts = list("head")
	is_monitor = 1
	selectable = 0
	has_subtypes = null
