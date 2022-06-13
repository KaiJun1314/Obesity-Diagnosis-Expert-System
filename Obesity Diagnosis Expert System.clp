(deffunction precision (?num ?digits)
  (bind ?m (integer (** 10 ?digits)))
  (/ (integer (* ?num ?m)) ?m))

(defrule name
	(initial-fact)
	=>
	(printout t crlf "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" crlf)
	(printout t "               Welcome to Diet and Nutirtion Expert System	" crlf)
	(printout t "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" crlf crlf)
	(printout t "What is your name? :")
	(assert (name (readline)))
)

(defrule age
	(name ?)
	=>
	(printout t "Please enter your age :" )
	(assert (age(read)))
)

(defrule gender
	(age ?)
	=>
	(printout t "Please enter your gender (Male/Female):" )
	(assert (gender(read)))
)

(defrule height
	(gender ?)
	=>
	(printout t "Please enter your height (in cm):" )
	(assert (height(read)))
)

(defrule weight
	(height ?)
	=>
	(printout t "Please enter your weight (in kg):" )
	(assert (weight(read)))
)

(defrule calculate-BMI
	(weight ?w)
	(height ?h)
	=>
	(assert (bmi (precision (/ ?w (* (/ ?h 100)(/ ?h 100)))2 )))
)

(defrule BMI-status-underweight
	(bmi ?bmi)
	=>
	(if(< ?bmi 18.5)
	then
	(assert (body-status underweight))
	(assert (suggest "Please gain some weight to maintain a healthy body")))
)

(defrule BMI-status-HealthyWeight
	(bmi ?bmi)
	=>
	(if (and (>= ?bmi 18.5)(< ?bmi 25.0))
	then	
	(assert (body-status Healthy-Weight))
	(assert (suggest "Good, keep your body weight")))
)

(defrule BMI-status-Overweight
	(bmi ?bmi)
	=>
	(if (and (>= ?bmi 25.0) (< ?bmi 30.0))
	then
	(assert (body-status Overweight))
	(assert (suggest "We strongly suggest you to lose some weight")))
)

(defrule BMI-status-Obesity
	(bmi ?bmi)
	=>
	(if (>= ?bmi 30)
	then
	(assert (body-status Obesity))
	(assert (suggest "We strongly suggest you to lose some weight")))
)

(defrule activityfactor-choose
	(bmi ?)
	=>
	(printout t crlf "Please select your activity range" crlf)
	(printout t "1. Sedentary (Little to no exercise )" crlf)
	(printout t "2. Light exercise (1-3 days per week)" crlf)	
	(printout t "3. Moderate exercise (3-5 days per week)" crlf)
	(printout t "4. Heavy exercise (6-7 days per week)" crlf)
	(printout t "5. Very heavy exercise (twice per day, extra heavy workouts)" crlf)
	(printout t "Enter your choice here : ")
	(assert (activityfactor-choice(read)))
)


(defrule activityfactor-real
	(activityfactor-choice ?afc)
	=>
	(if(= ?afc 1)
	then
	(assert (activityfactor 1.2)))
	(if(= ?afc 2)
	then
	(assert (activityfactor 1.3)))
	(if(= ?afc 3)
	then
	(assert (activityfactor 1.5)))
	(if(= ?afc 4)
	then
	(assert (activityfactor 1.7)))
	(if(= ?afc 5)
	then
	(assert (activityfactor 1.9)))
)

(defrule calorie_cal_male
	(activityfactor ?af)
	(gender Male)
	(height ?h)
	(age ?a)
	(weight ?w)
	=>
	(assert (calorie (* (+ (- (+ (* 10 ?w) (* 6.25 ?h))(* 5 ?a)) 5) ?af)))
)

(defrule calorie_cal_female
	(activityfactor ?af)
	(gender Female)
	(height ?h)
	(age ?a)
	(weight ?w)
	=>
	(assert (calorie (* (- (- (+ (* 10 ?w) (* 6.25 ?h))(* 5 ?a)) 161) ?af)))
)

(defrule calc-protein
	(weight ?w)
	=> 
	(assert (protein (* 0.8 ?w)))
)

(defrule calc-calcium
	(age ?a)
	(gender ?g)
	=> 
	(if (< ?a 1)
	then 
	(assert (calcium 270))
	else 
		(if (<= ?a 3)
		then
		(assert (calcium 500))
		else
			(if (<= ?a 8) 
			then
			(assert (calcium 700))
			else 
				(if (<= ?a 11)
				then
				(assert (calcium 1000))
				else
					(if (<= ?a 18)
					then 
					(assert (calcium 1300))
					else 
						(if (and (<= ?a 50) (eq ?g Female))
						then 
						(assert (calcium 1000))
						else
							(if (and (<= ?a 70) (eq ?g Female))
							then 
							(assert (calcium 1300))
							else
								(if (<= ?a 70)
								then 
								(assert (calcium 1000))
								else 
								(assert (calcium 1300))
								) 
							)
						)
					)
				)
			)
		)
	)
)

(defrule calc-fiber-child
	(age ?a)
	=>
	(if (<= ?a 18)
		then
		(assert (fiber 31))
	)
)

(defrule calc-fiber-male
	(age ?a)
	(gender Male)
	=>
	(if (and (>= ?a 19) (<= ?a 50) )
			then
			(assert (fiber 38))
	else
		(if (> ?a 50)
			then
			(assert (fiber 30))
		)
	)
)

(defrule calc-fiber-female
	(age ?a)
	(gender Female)
	=>
	(if (and (>= ?a 19) (<= ?a 50) )
			then
			(assert (fiber 25))
	else
		(if (> ?a 50)
			then
			(assert (fiber 21))
		)
	)
	
)

(defrule calc-carbohydrate
	(calorie ?c)
	=>
	(assert (carbohydrate (precision (/ (/ ?c 2) 4) 2) ) )
)

(defrule print-result
	(gender ?gender)
	(name ?name)
	(bmi ?bmi)
	(body-status ?bs)
	(calorie ?calorie)
	(protein ?protein)
	(suggest ?suggest)
	(calcium ?c)
	(fiber ?f)
	(carbohydrate ?ch)
	=>

	(if(eq ?gender Male)
	then 
	(bind ?title "Mr."))
	(if(eq ?gender Female)
	then 
	(bind ?title "Ms."))

	(printout t crlf "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" crlf)
	(printout t "            		Result				" crlf)
	(printout t "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" crlf crlf)
	(printout t "Dear "?title ?name crlf)
	(printout t "Your BMI is :" ?bmi crlf)
	(printout t "It is consider as " ?bs crlf)
	(printout t ?suggest crlf)

	(printout t crlf "Your suggested daily nutrient intake :" crlf)
	(printout t "Calories : " ?calorie crlf)
	(printout t "Protein (at least) : " ?protein " grams" crlf)
	(printout t "Calcium (at least) : " ?c " mg" crlf)
	(printout t "Fiber (at least) : " ?f " grams" crlf)
	(printout t "Carbohydrate (at least) : " ?ch " grams" crlf)
	(assert (print-result))
)