CREATE DATABASE FoodInspections
GO
USE FoodInspections
GO
/*
Creacion de las tablas
*/
CREATE TABLE Establecimientos(estNumero int identity not null, 
                              estNombre varchar(40) not null, 
							  estDireccion varchar(60) not null, 
							  estTelefono varchar(50), 
							  estLatitud money, 
							  estLongitud money,
							  constraint pk_Estab primary key(estNumero))
GO
CREATE TABLE Licencias(licNumero int identity not null, 
                       estNumero int not null, 
					   licFchEmision date, 
					   licFchVto date, 
					   licStatus character(3) not null,
					   constraint pk_Licencia primary key(licNumero),
					   constraint fk_EstLic foreign key(estNumero) references Establecimientos(estNumero),
					   constraint ck_StatusLic check(licStatus in ('APR','REV')))
GO
CREATE TABLE TipoViolacion(violCodigo int identity not null, 
                           violDescrip varchar(30) not null,
						   constraint pk_TipoViol primary key(violCodigo))
GO
CREATE TABLE Inspecciones(inspID int identity not null, 
                          inspFecha datetime, 
						  estNumero int not null, 
						  inspRiesgo varchar(5) not null, 
						  inspResultado varchar(25) not null, 
						  violCodigo int not null, 
						  inspComents varchar(100),
						  constraint pk_Inspect primary key(inspID),
						  constraint fk_EstabInsp foreign key(estNumero) references Establecimientos(estNumero),
						  constraint fk_ViolInsp foreign key(violCodigo) references TipoViolacion(violCodigo),
						  constraint ck_Riesgo check(inspRiesgo IN('Bajo','Medio','Alto')),
						  constraint ck_Result check(inspResultado IN('Pasa', 'Falla', 'Pasa con condiciones', 'Oficina no encontrada')))
GO

--1. Creación de índices que considere puedan ser útiles para optimizar las consultas (según criterio 
--establecido en el curso).

--INDEX LICENCIAS
CREATE INDEX IDX_LICENCIAS_estNumero ON Licencias(estNumero)

--INDEX INSPECCIONES
CREATE INDEX IDX_INSPECCIONES_estNumero ON Inspecciones(estNumero)
CREATE INDEX IDX_INSPECCIONES_violCodigo ON Inspecciones(violCodigo)


--2. Ingreso de un juego completo de datos de prueba (será más valorada la calidad de los datos que la 
--cantidad).

INSERT INTO Establecimientos(estNombre, estDireccion, estTelefono, estLatitud, estLongitud)
VALUES 
    ('Restaurante XYZ', '123 Calle Principal', '555-1234', 40.7128, -74.0060),
    ('Cafetería ABC', '456 Avenida Secundaria', '555-5678', 34.0522, -118.2437),
    ('Pizzería 123', '789 Calle Postre', '555-9012', 51.5074, -0.1278),
    ('Bar de Tapas', '321 Calle de la Fiesta', NULL, 48.8566, 2.3522),
    ('Restaurante Italiano', '987 Calle de la Pasta', '555-3456', 35.6895, 139.6917),
    ('Café del Parque', '654 Avenida del Bosque', '555-7890', 37.7749, -122.4194),
	('Sushi Express', '246 Calle del Pescado', '555-6789', 37.7749, -122.4194),
    ('Taco Paradise', '135 Avenida del Maíz', '555-4321', 34.0522, -118.2437),
    ('Buffet Asiático', '789 Avenida de los Sabores', '555-9876', 40.7128, -74.0060),
    ('Bar de Vinos', '531 Calle de las Uvas', '555-5432', 51.5074, -0.1278),
    ('Parrilla Argentina', '672 Avenida del Asado', '555-8765', 35.6895, 139.6917),
    ('Café Bohemio', '987 Calle del Café', '555-2109', 48.8566, 2.3522);


INSERT INTO Licencias(estNumero, licFchEmision, licFchVto, licStatus)
VALUES 
    (1, '2024-06-01', '2025-06-01', 'APR'),
    (2, '2024-06-02', '2025-06-02', 'APR'),
    (3, '2024-06-03', '2025-06-03', 'REV'),
    (4, '2024-06-04', '2025-06-04', 'APR'),
    (5, '2024-06-05', '2025-06-05', 'REV'),
    (6, '2024-06-06', '2025-06-06', 'APR'),
	(7, '2024-06-07', '2025-06-07', 'APR'),
    (8, '2024-06-08', '2025-06-08', 'REV'),
    (9, '2024-06-09', '2025-06-09', 'APR'),
    (10, '2024-06-10', '2025-06-10', 'REV'),
    (11, '2024-06-11', '2025-06-11', 'APR'),
    (12, '2024-06-12', '2025-06-12', 'REV');


INSERT INTO TipoViolacion(violDescrip) 
VALUES 
	('FaltaDeHigiene'),
    ('IncumplimientoDeNormativas'),
    ('ProblemasDeSeguridad'),
    ('FaltaMantenimiento'),
    ('VentilaciónInadecuada'),
    ('Contaminación'),
    ('ManipulaciónIncorrecta'),
    ('ProblemasEstructurales'),
	('ContaminacióndeAlimentos'),
    ('AusenciaSeñalización'),
    ('AusenciaEquiposEmergencia'),
    ('InsectosyPlagas'),
    ('ManipulacióndeSinGuantes'),
    ('AlmacenamientoInadecuado');



INSERT INTO Inspecciones(inspFecha, estNumero, inspRiesgo, inspResultado, violCodigo, inspComents)
VALUES 
    ('2024-06-01 09:00:00', 1, 'Bajo', 'Pasa', 1, 'Cumple con todas las normativas de higiene'),
    ('2024-06-02 10:00:00', 2, 'Medio', 'Falla', 3, 'Problemas de seguridad detectados'),
    ('2024-06-03 11:00:00', 3, 'Alto', 'Pasa con condiciones', 5, 'Problemas de ventilación detectados'),
    ('2024-06-04 12:00:00', 4, 'Medio', 'Falla', 4, 'Necesita mantenimiento urgente'),
    ('2024-06-05 13:00:00', 5, 'Bajo', 'Pasa', 2, 'Cumple con las normativas de manipulación de alimentos'),
    ('2024-06-06 14:00:00', 6, 'Alto', 'Oficina no encontrada', 8, 'No se pudo realizar la inspección'),
	('2024-06-07 09:00:00', 7, 'Bajo', 'Pasa', 6, 'Cumple con todas las normativas de contaminación'),
    ('2024-06-08 10:00:00', 8, 'Medio', 'Falla', 4, 'Problemas de mantenimiento detectados'),
    ('2024-06-09 11:00:00', 9, 'Alto', 'Pasa con condiciones', 1, 'Problemas de higiene detectados'),
    ('2024-06-10 12:00:00', 10, 'Medio', 'Falla', 3, 'Falta de equipos de emergencia'),
    ('2024-06-11 13:00:00', 11, 'Bajo', 'Pasa', 5, 'Cumple con las normativas de ventilación'),
    ('2024-06-12 14:00:00', 12, 'Alto', 'Oficina no encontrada', 2, 'No se pudo realizar la inspección');

SELECT * FROM Establecimientos
SELECT * FROM Licencias
SELECT * FROM TipoViolacion
SELECT * FROM Inspecciones



--3. Utilizando SQL implementar las siguientes consultas:

--a. Mostrar nombre, dirección y teléfono de los establecimientos que tuvieron la inspección fallida 
--más reciente.

SELECT e.estNombre , e.estDireccion , e.estTelefono 
FROM Establecimientos e
INNER JOIN Inspecciones i on i.estNumero = e.estNumero
WHERE i.inspResultado = 'Falla' and i.inspFecha = (SELECT MAX(ins.inspFecha) FROM Inspecciones ins)


--b. Mostrar los 5 tipos de violaciones mas comunes, el informe debe mostrar código y descripción 
--de la violación y cantidad de inspecciones en el año presente.

SELECT TOP 5  tv.violCodigo , tv.violDescrip , COUNT(i.inspID) as cantidadDeInspeccione
FROM TipoViolacion tv
INNER JOIN Inspecciones i on i.violCodigo = tv.violCodigo
WHERE YEAR(i.inspFecha) = YEAR(GETDATE())
GROUP BY tv.violCodigo , tv.violDescrip



--c. Mostrar número y nombre de los establecimientos que cometieron todos los tipos de violación 
--que existen.

SELECT e.estNumero , e.estNombre 
FROM Establecimientos e
INNER JOIN Inspecciones i on i.estNumero = e.estNumero
INNER JOIN TipoViolacion tv on tv.violCodigo = i.violCodigo
WHERE tv.violCodigo = ALL (SELECT DISTINCT i.violCodigo
							FROM Inspecciones i
							GROUP BY i.violCodigo
							HAVING COUNT(DISTINCT i.violCodigo) = (SELECT COUNT(DISTINCT i.violCodigo)
																	FROM Inspecciones i))

SELECT e.estNombre , tv.violCodigo
FROM Establecimientos e
INNER JOIN Inspecciones i on i.estNumero = e.estNumero
INNER JOIN TipoViolacion tv on i.violCodigo = tv.violCodigo 

--d. Mostrar el porcentaje de inspecciones reprobadas por cada establecimiento, incluir dentro de 
--la reprobación las categorías 'Falla', 'Pasa con condiciones'.


--e. Mostrar el ranking de inspecciones de establecimientos, dicho ranking debe mostrar número 
--y nombre del establecimiento, total de inspecciones, total de inspecciones aprobadas 
--('Pasa'), porcentaje de dichas inspecciones aprobadas, total de inspecciones reprobadas 
--('Falla', 'Pasa con condiciones') y porcentaje de dichas inspecciones reprobadas, solo 
--tener en cuenta establecimientos cuyo status de licencia es APR.


--f. Mostrar la diferencia de días en que cada establecimiento renovó su licencia.

--4. Utilizando T-SQL realizar los siguientes ejercicios: 

--a. Escribir un procedimiento almacenado que dado un tipo de riesgo ('Bajo','Medio','Alto'), 
--muestre los datos de las violaciones (violCodigo, violDescrip) para dicho tipo, no devolver 
--datos repetidos.

--b. Mediante una función que reciba un código de violación, devolver cuantos establecimientos 
--con licencia vencida y nunca renovada tuvieron dicha violación.

--c. Escribir un procedimiento almacenado que dado un rango de fechas, retorne por parámetros 
--de salida la cantidad de inspecciones que tuvieron un resultado 'Oficina no encontrada' y la 
--cantidad de inspecciones que no tienen comentarios.

--5. Escribir los siguientes disparadores :
--a. Cada vez que se crea un nuevo establecimiento, se debe crear una licencia de aprobación 
--con vencimiento 90 días, el disparador debe ser escrito teniendo en cuenta la posibilidad de 
--ingresos múltiples.
--b. No permitir que se ingresen inspecciones de establecimientos cuya licencia está próxima a 
--vencer, se entiende por próxima a vencer a todas aquellas cuyo vencimiento esté dentro de 
--los siguientes 5 días, el disparador debe tener en cuenta la posibilidad de registros 
--múltiples.

--6. Escribir una vista que muestre todos los datos de las licencias vigentes y los días que faltan para 
--el vencimiento de cada una de ellas.

--7. Los inspectores de la ciudad interactúan entre ellos utilizando una plataforma interna, en la misma 
--a modo de chat comparten información referente a las inspecciones que vienen realizando, los 
--establecimientos involucrados y los resultados de cada inspección. Se solicita al alumno crear una 
--colección en MongoDB para poder mantener el histórico de conversaciones y luego hacer algunas 
--consultas sobre dicho histórico, se pide como mínimo poder consultar:

--a. Cuantas conversaciones sobre violaciones diferentes se constataron.

--b. Obtener los mejores establecimientos basado en la cantidad de inspecciones aprobadas.

--c. Modificar una conversación agregando una etiqueta “IMPORTANTE” para todos aquellos 

--chats que tengan referencia a resultados reprobados ('Falla')