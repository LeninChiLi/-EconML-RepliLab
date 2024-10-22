*==========================================
* PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ 
* Docente: Max Chipani
*==========================================

*=============================
* I. Organización de Carpetas
*=============================

global main "C:/Users/maxle/Documents/GitHub/-EconML-RepliLab"


* Definir las subcarpetas usando globals
global do_files   "$main/papers/paper_David_Card_1993_Replication/code/stata"     // Carpeta para los .do files
global data       "$main/_data"                         // Carpeta para los datos
global results    "$main/papers/paper_David_Card_1993_Replication/results"  


cd "$data"


* Cargar el dataset desde la carpeta de datos
use "$data/card.dta", clear

*==========================================
* Pregunta 1: Descripción de las características de los individuos (2 puntos)
*==========================================
* Age distribution
gen age_group = .
replace age_group = 1 if age >= 14 & age <= 15
replace age_group = 2 if age >= 16 & age <= 17
replace age_group = 3 if age >= 18 & age <= 20
replace age_group = 4 if age >= 21 & age <= 24
label define age_group 1 "Age 14-15" 2 "Age 16-17" 3 "Age 18-20" 4 "Age 21-24"
label values age_group age_group
tabulate age_group

* Regional distribution
gen region = .
replace region = 1 if reg661 == 1  // Northeast
replace region = 2 if reg662 == 1  // Midwest
replace region = 3 if reg663 == 1  // South
replace region = 4 if reg664 == 1  // West
label define region 1 "Northeast" 2 "Midwest" 3 "South" 4 "West"
label values region region
tabulate region

* Lived in SMSA in 1966
tabulate smsa66

* Lived near a 4-year college in 1966
tabulate nearc4

* Family structure at age 14
tabulate momdad14

* Parental education
summarize fatheduc motheduc

* Percent Black
tabulate black

* Mean education
summarize educ

* Mean wage
summarize wage

* Southern region
tabulate south
* (agregar más comandos de descripción según las variables de interés)

*==========================================
* Pregunta 2: Regresión OLS para lwage (2 puntos)
*==========================================
regress lwage educ exper exper2 black south smsa reg661-reg668 smsa66
* Comentar resultados en relación con la Tabla 2, Columna 2 del paper de Card (1993)

*==========================================
* Pregunta 3: Posibles fuentes de sesgo en el retorno económico por año de educación (2 puntos)
*==========================================
* Comenta en un archivo de texto por separado los tres argumentos de sesgo que consideras relevantes
* Por ejemplo, puedes usar una sección de comentarios extensa para anotar tu análisis

*==========================================
* Pregunta 4: Estimación de la ecuación para educ usando nearc4 (2 puntos)
*==========================================
regress educ educ exper exper2 black south smsa reg661-reg668 smsa66 nearc4
* Comenta sobre la correlación parcial entre educ y nearc4

*==========================================
* Pregunta 5: Estimación de lwage por Variables Instrumentales (2 puntos)
*==========================================
ivregress 2sls lwage (educ = nearc4) exper exper2 black south smsa reg661-reg668 smsa66
* Comentar los resultados y compararlos con los obtenidos en la regresión OLS de la Pregunta 2

*==========================================
* Pregunta 6: Comparación de intervalos de confianza (2 puntos)
*==========================================
* Compara los intervalos de confianza de la estimación por OLS y por VI

*==========================================
* Pregunta 7: Test de Cragg y Donald para instrumentos débiles (2 puntos)
*==========================================
estat firststage
* Usa el estadístico de Cragg y Donald y consulta las tablas de Stock y Yogo (2005)

*==========================================
* Pregunta 8: Estimación con nearc2 y nearc4 como instrumentos (2 puntos)
*==========================================
regress educ nearc2 nearc4 exper exper2 black south smsa reg661-reg668 smsa66
ivregress 2sls lwage (educ = nearc2 nearc4) exper exper2 black south smsa reg661-reg668 smsa66
* Discute los resultados y cómo cambian en comparación con la Pregunta 7

*==========================================
* Pregunta 9: Comparación entre VI y 2SLS (2 puntos)
*==========================================
* Analiza si los métodos de VI y 2SLS son equivalentes en este caso.

*==========================================
* Pregunta 10: Test de Sargan para restricciones de sobre-identificación (2 puntos)
*==========================================
ivregress 2sls lwage (educ = nearc2 nearc4) exper exper2 black south smsa reg661-reg668 smsa66
predict ub, residuals
regress ub nearc2 nearc4 exper exper2 black south smsa reg661-reg668 smsa66
gen sargan = e(N) * r2
display "Sargan Test Statistic: " sargan
* Comenta los resultados obtenidos

*==========================================
* Fin de la Tarea
*==========================================