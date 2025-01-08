-- -- ANALISIS DE TENDENCIAS DE CONTENIDO:

-- Identificar qué tipos de contenido (Movies vs TV Shows) son más frecuentes en Netflix a lo largo de los años:
SELECT 
    SUBSTR(date_added, -4) AS year_added, -- Extrae los últimos 4 caracteres de la columna "date_added" que representan el año
    type,
    COUNT(*) AS quantity_added -- Cuenta todas las filas dentro de cada combinación de "year_added" y "type"
FROM netflix_titles
WHERE date_added IS NOT NULL -- Filtra los registros sin valores en la columna "date_added"
GROUP BY year_added, type -- Agrupa los datos por año extraído y tipo de contenido
ORDER BY year_added DESC, quantity_added DESC -- Ordena los resultados por año y luego por la cantidad de títulos en orden descendente.
; 

-- Analizar los géneros más populares según la clasificación en "listed_in":
SELECT 
    listed_in, 
    COUNT(*) AS quantity_added -- Cuenta cuántas veces aparece cada combinación de géneros
FROM netflix_titles
WHERE listed_in IS NOT NULL
GROUP BY listed_in -- Agrupa los resultados por las combinaciones completas de géneros
ORDER BY quantity_added DESC -- Ordena las combinaciones por su frecuencia, de mayor a menor
;

-- CLASIFICACION POR RATING:

-- Analizar la distribución de clasificaciones por "rating":
SELECT 
    rating, 
    COUNT(*) AS quantity -- Cuenta cuántos títulos tienen cada clasificación
FROM netflix_titles
WHERE rating IS NOT NULL -- Filtra los registros para excluir los que no tienen clasificación
GROUP BY rating
ORDER BY quantity DESC -- Ordena las clasificaciones por frecuencia, de mayor a menor
;

-- DURACION DE CONTENIDOS:

-- Analizar la duración promedio de películas y series:
-- Duracion promedio de peliculas en minutos:
SELECT 
    type, 
    AVG(CAST(REPLACE(duration, "min", "") AS INTEGER)) AS avg_duration -- REPLACE elimina el texto "min" de la columna duration para trabajar con los valores numéricos y CAST convierte los valores numéricos en enteros para calcular el promedio
FROM netflix_titles
WHERE type = "Movie" AND duration LIKE "% min" -- Filtra solo las filas correspondientes a películas con duración en minutos
GROUP BY type
;

-- Duracion promedio de las series por temporada:
SELECT 
    type,
    AVG(CAST(REPLACE(duration, "Season", "") AS INTEGER)) AS avg_duration -- REPLACE elimina el texto "Season" de la columna duration para trabajar con los valores numéricos y CAST convierte los valores numéricos en enteros para calcular el promedio
FROM netflix_titles
WHERE type = "TV Show" AND duration LIKE "% Season%" -- Filtra solo las filas correspondientes a series con duración en temporadas.
GROUP BY type
;

-- Comparar la duración de contenidos según el género:
SELECT 
    listed_in,
    type,
    AVG(CAST(REPLACE(duration, ' min', '') AS INTEGER)) AS avg_duration -- Calcula la duración promedio para cada combinación de géneros
FROM netflix_titles
WHERE type = 'Movie' AND duration LIKE '% min' -- Filtra por películas con duración en minutos
GROUP BY listed_in, type
ORDER BY avg_duration DESC;

-- ANALISIS TEMPORAL:

-- Explorar el impacto de la fecha de lanzamiento en la adición de títulos:
-- Primero, normalizar el Campo "date_added" ya que esta en formato "text"
SELECT 
    release_year, 
    strftime('%Y', date_added) AS year_added
FROM netflix_titles
WHERE date_added IS NOT NULL
;

-- Segundo, analizar la Relación entre "release_year" y "date_added"
SELECT 
    release_year,
    strftime('%Y', date_added) AS year_added, -- Extrae el año de la fecha en que se agregó el título
    COUNT(*) AS title_count
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY release_year, year_added
ORDER BY release_year, year_added
;

-- Tercero, calcular el tiempo promedio entre el año de lanzamiento (release_year) y el año de adición (year_added)
SELECT 
    strftime('%Y', date_added) AS year_added, -- Extrae el año en que se agregó el título a Netflix (year_added)
    AVG(CAST(strftime('%Y', date_added) AS INTEGER) - release_year) AS avg_delay -- Calcula la diferencia entre el año de adición y el año de lanzamiento
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY year_added
ORDER BY year_added
;

-- DIRECTORES Y ACTORES MAS PROLIFICOS:

-- Identificar los directores con más títulos en la plataforma:
SELECT 
    director,
    COUNT(*) AS title_count
FROM netflix_titles
WHERE director IS NOT NULL
GROUP BY director
ORDER BY title_count DESC
LIMIT 10
;

-- Crear una lista de actores que aparecen con mayor frecuencia:
SELECT 
    casting,
    COUNT(*) AS title_count
FROM netflix_titles
WHERE casting IS NOT NULL
GROUP BY casting
ORDER BY title_count DESC
LIMIT 10
;

-- SEGEMENTACION POR PAIS:

-- Analizar qué países producen más contenido en Netflix:
SELECT 
    country,
    COUNT(*) AS content_count
FROM netflix_titles
WHERE country IS NOT NULL
GROUP BY country
ORDER BY content_count DESC
LIMIT 10
;

-- Comparar la distribución de géneros por país:
SELECT 
    country,
    listed_in,
    COUNT(*) AS genre_count
FROM netflix_titles
WHERE country IS NOT NULL AND listed_in IS NOT NULL
GROUP BY country, listed_in
ORDER BY country, genre_count DESC
;