/datum/chemical_reaction/hydrocodone
	name = "Гидрокон"
	id = "hydrocodone"
	result = "hydrocodone"
	required_reagents = list("morphine" = 1, "sacid" = 1, "water" = 1, "oil" = 1)
	result_amount = 2

/datum/chemical_reaction/mitocholide
	name = "mitocholide"
	id = "mitocholide"
	result = "mitocholide"
	required_reagents = list("synthflesh" = 1, "cryoxadone" = 1, "plasma" = 1)
	result_amount = 3

/datum/chemical_reaction/cryoxadone
	name = "Криоксадон"
	id = "cryoxadone"
	result = "cryoxadone"
	required_reagents = list("cryostylane" = 1, "plasma" = 1, "acetone" = 1, "mutagen" = 1)
	result_amount = 4
	mix_message = "The solution bubbles softly."
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/chemical_reaction/spaceacillin
	name = "Космоцилин"
	id = "spaceacillin"
	result = "spaceacillin"
	required_reagents = list("fungus" = 1, "ethanol" = 1)
	result_amount = 2
	mix_message = "The solvent extracts an antibiotic compound from the fungus."

/datum/chemical_reaction/rezadone
	name = "Резадон"
	id = "rezadone"
	result = "rezadone"
	required_reagents = list("carpotoxin" = 1, "spaceacillin" = 1, "copper" = 1)
	result_amount = 3

/datum/chemical_reaction/sterilizine
	name = "Стерилизин"
	id = "sterilizine"
	result = "sterilizine"
	required_reagents = list("antihol" = 2, "chlorine" = 1)
	result_amount = 3

/datum/chemical_reaction/charcoal
	name = "Активированный уголь"
	id = "charcoal"
	result = "charcoal"
	required_reagents = list("ash" = 1, "sodiumchloride" = 1)
	result_amount = 2
	mix_message = "Смешивание даёт мелкий чёрный порошок."
	min_temp = T0C + 100
	mix_sound = 'sound/goonstation/misc/fuse.ogg'

/datum/chemical_reaction/silver_sulfadiazine
	name = "Сульфадиазин серебра"
	id = "silver_sulfadiazine"
	result = "silver_sulfadiazine"
	required_reagents = list("ammonia" = 1, "silver" = 1, "sulfur" = 1, "oxygen" = 1, "chlorine" = 1)
	result_amount = 5
	mix_message = "A strong and cloying odor begins to bubble from the mixture."
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/chemical_reaction/salglu_solution
	name = "Физраствор с глюкозой"
	id = "salglu_solution"
	result = "salglu_solution"
	required_reagents = list("sodiumchloride" = 1, "water" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/heparin
	name = "Гепарин"
	id = "Heparin"
	result = "heparin"
	required_reagents = list("sugar" = 1, "meatslurry" = 1, "phenol" = 1, "sacid" = 1)
	result_amount = 2

/datum/chemical_reaction/synthflesh
	name = "Синтплоть"
	id = "synthflesh"
	result = "synthflesh"
	required_reagents = list("blood" = 1, "carbon" = 1, "styptic_powder" = 1)
	result_amount = 3
	mix_message = "The mixture knits together into a fibrous, bloody mass."
	mix_sound = 'sound/effects/blobattack.ogg'

/datum/chemical_reaction/styptic_powder
	name = "Кровоостанавливающая пудра"
	id = "styptic_powder"
	result = "styptic_powder"
	required_reagents = list("aluminum" = 1, "hydrogen" = 1, "oxygen" = 1, "sacid" = 1)
	result_amount = 4
	mix_message = "The solution yields an astringent powder."

/datum/chemical_reaction/calomel
	name = "Каломель"
	id = "calomel"
	result = "calomel"
	required_reagents = list("mercury" = 1, "chlorine" = 1)
	result_amount = 2
	min_temp = T0C + 100
	mix_message = "Stinging vapors rise from the solution."

/datum/chemical_reaction/potass_iodide
	name = "Йодид калия"
	id = "potass_iodide"
	result = "potass_iodide"
	required_reagents = list("potassium" = 1, "iodine" = 1)
	result_amount = 2
	mix_message = "The solution settles calmly and emits gentle fumes."

/datum/chemical_reaction/pen_acid
	name = "Пентетиновая кислота"
	id = "pen_acid"
	result = "pen_acid"
	required_reagents = list("fuel" = 1, "chlorine" = 1, "ammonia" = 1, "formaldehyde" = 1, "sodium" = 1, "cyanide" = 1)
	result_amount = 6
	mix_message = "The substance becomes very still, emitting a curious haze."

/datum/chemical_reaction/sal_acid
	name = "Salicyclic Acid"
	id = "sal_acid"
	result = "sal_acid"
	required_reagents = list("sodium" = 1, "phenol" = 1, "carbon" = 1, "oxygen" = 1, "sacid" = 1)
	result_amount = 5
	mix_message = "The mixture crystallizes."
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/chemical_reaction/salbutamol
	name = "Сальбутамол"
	id = "salbutamol"
	result = "salbutamol"
	required_reagents = list("sal_acid" = 1, "lithium" = 1, "aluminum" = 1, "bromine" = 1, "ammonia" = 1)
	result_amount = 5
	mix_message = "The solution bubbles freely, creating a head of bluish foam."
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/chemical_reaction/perfluorodecalin
	name = "Перфтордекалин"
	id = "perfluorodecalin"
	result = "perfluorodecalin"
	required_reagents = list("hydrogen" = 1, "fluorine" = 1, "oil" = 1)
	result_amount = 3
	min_temp = T0C + 100
	mix_message = "The mixture rapidly turns into a dense pink liquid."
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/chemical_reaction/ephedrine
	name = "Эфедрин"
	id = "ephedrine"
	result = "ephedrine"
	required_reagents = list("sugar" = 1, "oil" = 1, "hydrogen" = 1, "diethylamine" = 1)
	result_amount = 4
	mix_message = "The solution fizzes and gives off toxic fumes."

/datum/chemical_reaction/diphenhydramine
	name = "Diphenhydramine"
	id = "diphenhydramine"
	result = "diphenhydramine"
	required_reagents = list("oil" = 1, "carbon" = 1, "bromine" = 1, "diethylamine" = 1, "ethanol" = 1)
	result_amount = 4
	mix_message = "The mixture fizzes gently."
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/chemical_reaction/oculine
	name = "Окулин" // Oculine
	id = "oculine"
	result = "oculine"
	required_reagents = list("atropine" = 1, "spaceacillin" = 1, "salglu_solution" = 1)
	result_amount = 3
	mix_message = "The mixture settles, becoming a milky white."

/datum/chemical_reaction/atropine
	name = "Атропин"
	id = "atropine"
	result = "atropine"
	required_reagents = list("ethanol" = 1, "acetone" = 1, "diethylamine" = 1, "phenol" = 1, "sacid" = 1)
	result_amount = 5
	mix_message = "A horrid smell like something died drifts from the mixture."

/datum/chemical_reaction/epinephrine
	name = "Эпинефрин"
	id = "epinephrine"
	result = "epinephrine"
	required_reagents = list("phenol" = 1, "acetone" = 1, "diethylamine" = 1, "oxygen" = 1, "chlorine" = 1, "hydrogen" = 1)
	result_amount = 6
	mix_message = "Tiny white crystals precipitate out of the solution."
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/chemical_reaction/strange_reagent
	name = "Странный реагент"
	id = "strange_reagent"
	result = "strange_reagent"
	required_reagents = list("omnizine" = 1, "holywater" = 1, "mutagen" = 1)
	result_amount = 3
	mix_message = "The substance begins moving on its own somehow."

/datum/chemical_reaction/life
	name = "Жизнь"
	id = "life"
	result = null
	required_reagents = list("strange_reagent" = 1, "synthflesh" = 1, "blood" = 1)
	result_amount = 1
	min_temp = T0C + 100

/datum/chemical_reaction/life/on_reaction(datum/reagents/holder, created_volume)
	chemical_mob_spawn(holder, rand(1, round(created_volume, 1)), "Life (hostile)") //defaults to HOSTILE_SPAWN

/datum/chemical_reaction/life/friendly
	name = "Жизнь (дружелюбная)"
	id = "life_friendly"
	required_reagents = list("strange_reagent" = 1, "synthflesh" = 1, "sugar" = 1)

/datum/chemical_reaction/life/friendly/on_reaction(datum/reagents/holder, created_volume)
	chemical_mob_spawn(holder, rand(1, round(created_volume, 1)), "Life (friendly)", FRIENDLY_SPAWN)

/datum/chemical_reaction/mannitol
	name = "Маннитол"
	id = "mannitol"
	result = "mannitol"
	required_reagents = list("sugar" = 1, "hydrogen" = 1, "water" = 1)
	result_amount = 3
	mix_message = "The mixture bubbles slowly, making a slightly sweet odor."

/datum/chemical_reaction/mutadone
	name = "Мутадон"
	id = "mutadone"
	result = "mutadone"
	required_reagents = list("mutagen" = 1, "acetone" = 1, "bromine" = 1)
	result_amount = 3
	mix_message = "A foul astringent liquid emerges from the reaction."

/datum/chemical_reaction/antihol
	name = "антиголь"
	id = "antihol"
	result = "antihol"
	required_reagents = list("ethanol" = 1, "charcoal" = 1)
	result_amount = 2
	mix_message = "Шипящая свесь источает мятный освежающий запах."
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/chemical_reaction/teporone
	name = "Тепорон"
	id = "teporone"
	result = "teporone"
	required_reagents = list("acetone" = 1, "silicon" = 1, "plasma" = 1)
	result_amount = 2
	mix_message = "Смесь приобретает странный лавандовый цвет."
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/chemical_reaction/haloperidol
	name = "Галоперидол"
	id = "haloperidol"
	result = "haloperidol"
	required_reagents = list("chlorine" = 1, "fluorine" = 1, "aluminum" = 1, "potass_iodide" = 1, "oil" = 1)
	result_amount = 4
	mix_message = "Химикаты смешиваются в странную розовую жижу."

/datum/chemical_reaction/ether
	name = "Эфир"
	id = "ether"
	result = "ether"
	required_reagents = list("sacid" = 1, "ethanol" = 1, "oxygen" = 1)
	result_amount = 1
	mix_message = "The mixture yields a pungent odor, which makes you tired."
	mix_message = "Смесь издаёт едкий запах, навевающий сонливость…"

/datum/chemical_reaction/degreaser
	name = "Обезжириватель"
	id = "degreaser"
	result = "degreaser"
	required_reagents = list("oil" = 1, "sterilizine" = 1)
	result_amount = 2

/datum/chemical_reaction/liquid_solder
	name = "Жидкий припой"
	id = "liquid_solder"
	result = "liquid_solder"
	required_reagents = list("ethanol" = 1, "copper" = 1, "silver" = 1)
	result_amount = 3
	min_temp = T0C + 100
	mix_message = "Металлически поблескивающая смесь мягко булькает."
