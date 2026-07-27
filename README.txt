Proyecto GBD: Sistema de Biblioteca Digital

Melany Asencio, Joshua Guzman y Alexis Peñafiel, 
Universidad Politécnica Salesiana
Gestión de Base de Datos
Ing. Daniel Humberto Plua Moran
24 de julio del 2026

1. Introducción
1.1 Descripción del Proyecto
La digitalización y automatización de procesos bibliográficos es indispensable para garantizar acceso ágil, ordenado y seguro a la información. En el entorno actual, 
las bibliotecas modernas requieren sistemas de gestión capaces de administrar no solo catálogos bibliográficos de manera abstracta, sino también buscan un control 
riguroso de sus copias físicas, registros de usuarios y trazabilidad para las transacciones de préstamos y devoluciones.
Nuestro proyecto se enfoca en el desarrollo e implementación de un sistema de gestión para bibliotecas digitales, diseñado bajo una arquitectura relacional solida 
que asegure la integridad de los datos, la automatización de reglas de negocio y la optimización de las consultas operativas.
1.2 Problema a Solucionar
Llevar un control adecuado sobre libros, prestamos y usuarios puede convertirse en una tarea complicada para una biblioteca moderna, sobre todo cuando no se cuenta 
con una herramienta que permita la organización y administración de la información de forma eficiente. La falta de un sistema adecuado puede conducir a dificultades 
para conocer la disponibilidad real de ciertos libros o perder seguimiento de los tiempos de devolución; además, la ausencia de un espacio registro sobre el 
comportamiento de los usuarios limita la posibilidad de conocer su experiencia y mejorar los servicios ofrecidos por la biblioteca.
1.3 Objetivo General
Desarrollar un sistema para bibliotecas digitales que permita gestionar de manera eficiente la información relacionada con los libros, usuarios, préstamos y 
devoluciones; facilitando el control de los recursos bibliotecarios y mejorando la experiencia de los usuarios mediante el uso de tecnologías de bases de datos y 
herramientas de análisis de información. 
1.4 Objetivos Específicos
	1.Diseñar una base de datos que permita almacenar y organizar información referente a los libros, usuarios, préstamos y devoluciones.
	2.Implementar funciones, procedimientos y triggers que automaticen procesos importantes para el funcionamiento del sistema.
	3.Crear un módulo de comentarios utilizando MongoDB para que los usuarios puedan compartir opiniones y valoraciones sobre los libros.
	4.Implementar un Data Warehouse que permita el análisis de la información histórica de los préstamos para la generación de reportes gerenciales.
	5.Mejorar el control de la disponibilidad de los libros y el seguimiento de los préstamos realizados.

2. Desarrollo
2.1 Arquitectura Conceptual
El diseño de la base de datos fue estructurado buscándose la máxima normalización y eficiencia en la gestión del inventario y transacciones de la biblioteca. La 
arquitectura se divide conceptualmente en 3 bloques principales: catálogos maestros, gestión de inventario y flujo transaccional.
	1.Catálogos maestros (Autores y Categorías): Para evitar la redundancia de datos y prevenir anomalías de actualización, la información clasificatoria se aísla 
	en entidades independientes. Ambas entidades mantienen una relación “uno a muchos” (1:N) con la entidad Libros; esto significa que una categoría puede abarcar 
	muchos libros y un autor escribir múltiples obras, pero en el registro central cada libro pertenece a una sola categoría principal y autor.
	2.Separación lógica del inventario (Libros y Ejemplares): La entidad Libros almacena únicamente metadatos de la obra, véase el título, autor y categoría. Por 
	su parte, la entidad Ejemplares representa las copias físicas reales y disponibles. Se relación es de 1:N, esta separación permite a la biblioteca poseer múltiples copias físicas de una misma obra.
	3.Flujo transaccional (Usuarios, Prestamos y Devoluciones): El ciclo del servicio se modeló mediante u historial transaccional robusto. La entidad Prestamos 
	funciona como núcleo transaccional, actuando de tabla asociativa que registra que usuario se llevó qué copia física específica y en qué fechas. Se optó por 
	independizar el proceso de retorno de los ejemplares mediante una relación “uno a cero o uno” (1:0..1) con Prestamos; un préstamo existe desde el momento en 
	que el usuario retira el ejemplar físicamente, pero el registro en Devoluciones solo se genera cuando el ejemplar regresa físicamente. Esta separación permite 
	el control financiero y administrativo preciso, calculando días de retraso y penalizaciones de manera aislada al préstamo original.

2.2 Diseño Lógico
Partiendo de la arquitectura conceptual definida en el modelo Entidad-Relación, se procedió con el diseño de la base de datos relacional. En esta fase, las entidades 
relacionales son transformadas en tablas físicas, garantizando la integridad de los datos mediante la aplicación de formas normales. Se definen los identificadores 
únicos (Claves Primarias, PK) para cada tabla, y su establecen las relaciones entre entidades resolviéndose mediante la migración de estas claves como Claves Foráneas 
(FK) hacia las tablas dependientes. A continuación, se presenta el diseño de la base de datos relacional:
-Tabla CATEGORIAS
Atributo	Tipo de Clave
ID_CATEGORIA	PK
NOMBRE	
DESCRIPCION	

-Tabla AUTORES
Atributo	Tipo de Clave
ID_CATEGORIA	PK
NOMBRE	

-Tabla LIBROS
Atributo	Tipo de Clave
ID_LIBRO	PK
ID_CATEGORIA	FK
ID_AUTOR	FK
TITULO	
•ID_CATEGORIA → CATEGORIAS(ID_CATEGORIA)
•ID_AUTOR → AUTORES(ID_AUTOR)

-Tabla EJEMPLARES
Atributo		Tipo de Clave
ID_EJEMPLAR		PK
ID_LIBRO		FK
ESTADO_CONSERVACION	
DISPONIBLE	
•ID_LIBRO → LIBROS(ID_LIBRO)

-Tabla USUARIOS
Atributo		Tipo de Clave
CEDULA			PK
NOMBRE	
TELEFONO	
CORREO_ELECTRONICO	
ESTATUS	

-Tabla PRESTAMOS
Atributo		Tipo de Clave
ID_PRESTAMO		PK
CEDULA	FK
ID_EJEMPLAR		FK
FECHA_PRESTAMO	
FECHA_DEVOLUCION	
ESTADO	
•CEDULA → USUARIOS(CEDULA)
•ID_EJEMPLAR → EJEMPLARES(ID_EJEMPLAR)

-Tabla DEVOLUCIONES
Atributo		Tipo de Clave
ID_DEVOLUCION		PK
ID_PRESTAMO		FK
FECHA_RECEPCION	
DIAS_RETRASO	
PENALIZACION	
•ID_PRESTAMO → PRESTAMOS(ID_PRESTAMO)

-Relaciones Entre Tablas
Relación			    Cardinalidad
CATEGORIAS----LIBROS		       *1:N
AUTORES----LIBROS			1:N
LIBROS----EJEMPLARES			1:N
USUARIOS----PRESTAMOS			1:N
EJEMPLARES----PRESTAMOS			1:N
PRESTAMOS----DEVOLUCIONES	      **1:0..1
*: Se lee como: “Uno a Muchos”
**: Se lee como: “Uno a Uno Opcional”
2.3 Implementación Física
Para la materialización del modelo lógico propuesto, se desarrollaron los scripts de Data Definition Language (DDL) utilizando el dialecto de Oracle. El código se 
ejecutó y validó en la plataforma en línea SQL Live, garantizándose la correcta compilación de las estructuras y la aplicación estricta de las reglas de negocio a 
nivel de motor de base de datos.
Se prestó especial atención a la integridad referencial de las tablas, creándolas secuencialmente para asegurar la correcta vinculación de las FK. También se tomaron 
en cuenta las restricciones de dominio implementando las cláusulas CHECK en campos críticos para evitar la entrada de datos inconsistentes; por ejemplo, limitando el 
campo ESTATUS de los usuarios a “Activo”, “Inactivo”, o “Sancionado”; así como el ESTADO_CONSERVACION de los ejemplares a “Bueno”, Regular”, o “Dañado”.
2.4 Lógica de Negocio en Base de Datos
Para garantizar la consistencia de los datos y centralizar las reglas de negocio en la capa de base de datos, se desarrollaron funciones utilizando el lenguaje 
procedimental PL/SQL; el encapsular esta lógica a nivel de motor de base de datos, nos asegura que cualquier módulo superior consuma la misma validación, evitando 
posibles inconsistencias. Se detallan cuatro funciones principales implementadas para la gestión operativa del inventario y las validaciones de los usuarios.
	•FN_CANTIDAD_DISPONIBLE: Su objetivo es determinar cuántas copias físicas reales de una obra se encuentran aptas para los préstamos. Esta función cruza la 
	información de la tabla EJEMPLARES y LIBROS, filtrando aquellos registros cuto atributo “DISPONIBLE” sea igual a “S” (Sí).
	•FN_DISPONIBILIDAD_LIBRO: Como complemento de la función anterior, está diseñada para ser consumida por los módulos de interfaz o procesos que requieran una 
	respuesta cualitativa rápida. Evalúa el inventario del libro solicitado y emite un veredicto en formato de cadena de texto.
	•FN_PRESTAMOS_ACTIVOS_USER: Para que el sistema permita registrar un nuevo préstamo, es necesario conocer el historial del usuario. Esta función consulta la 
	tabla PRESTAMOS en busca de transacciones activas o vencidas asociadas a la identificación del solicitante, con fin de prevenir que usuarios sancionados sigan 
	retirando material.
	•FN_CALCULAR_PENALIZACION: Para mantener el control financiero y administrativo independiente del registro de préstamos, se desarrolló esta función matemática 
	con propósito de comparar las fechas máxima de devolución acortada frente a la de recepción real. De existir un retraso, se calcula el monto económico a 
	sancionar en función de una tarifa diaria preestablecida.
4. Triggers
•Trigger de validación de préstamo: Controla que el usuario exista y esté activo, que el ejemplar exista, se encuentre disponible y sin daños, y que la fecha límite 
sea posterior a la fecha de emisión del préstamo.
•Trigger para procesar el préstamo: Tras registrar el préstamo, el sistema actualiza automáticamente la disponibilidad del ejemplar a 'N' y registra el movimiento 
 correspondiente en el historial.
•Trigger para cálculo de multa: Se ejecuta antes de insertar una devolución y calcula automáticamente una sanción de USD 0,50 por cada día de retraso.
•Trigger para procesamiento de devolución: Al registrar la devolución, el estado del préstamo pasa a 'Devuelto', la entrega se registra en el historial y el ejemplar 
 vuelve a estar disponible, salvo que presente daños, en cuyo caso permanecerá no disponible.
•Trigger para registrar renovaciones: Cuando se modifica la fecha límite de un préstamo, el trigger registra la renovación en el historial.
5. Procedimientos Implementados 
•Procedimiento para registrar un préstamo: Recibe la cédula del usuario, el identificador del libro y la cantidad de días del préstamo, busca automáticamente un 
 ejemplar disponible y devuelve el identificador del préstamo generado.
•Procedimiento para registrar una devolución: Registra el retorno del ejemplar en el sistema, omitiendo el cálculo manual de la penalización y los días de mora, ya 
 que los valores de DIAS_RETRASO y PENALIZACION son procesados automáticamente por el trigger.
•Procedimiento para renovar un préstamo: Procedimiento para renovar un préstamo: Permite extender la fecha de devolución de un préstamo activo validando que 
 los días adicionales sean mayores a cero, que el registro exista y que no se encuentre vencido a la fecha actual.
•Procedimiento para aplicar o recalcular una multa: Este procedimiento permite recalcular una multa cuando ya existe una devolución.
•Procedimiento actualizar prestamos vencidos: Recorre la base de datos identificando los préstamos cuyo estado permanezca activo pero cuya fecha límite de 
 devolución sea menor a la fecha actual (SYSDATE), actualizando automáticamente su estado a 'Vencido' para reflejar la mora en el sistema.
6. Cursores 
•Préstamos activos: Consulta y retorna todos los préstamos en estado 'Activo', agrupando la información del préstamo, los datos del usuario, el título del libro y la 
 identificación del ejemplar, ordenando los resultados por la fecha límite de devolución.
•Usuarios con préstamos vencidos: Consulta a los usuarios que poseen préstamos vencidos o cuya fecha límite ya transcurrió sin ser devueltos, calculando 
 automáticamente la cantidad de préstamos morosos y el acumulado total de días de retraso por usuario.
7. Proceso ETL 
El proceso ETL (Extract, Transform, Load) permite extraer información desde la base de datos operacional del Sistema de Biblioteca Digital, aplicar transformaciones 
necesarias para mejorar la calidad y estructura de los datos, y finalmente cargar la información en el Data Warehouse diseñado bajo un esquema estrella. 
Extracción de datos (Extract): La extracción de información se realizó desde las tablas del sistema transaccional de la biblioteca, las cuales contienen la información 
operativa relacionada con usuarios, libros, autores, categorías y préstamos.
Transformación de datos
•Creación de dimensión tiempo: Se creó una dimensión temporal a partir de las fechas de préstamo, obteniendo información como día, nombre del día, mes, trimestre y año, 
 facilitando análisis por periodos. 
Campos generados:
oDía 
oMes 
oNombre del mes 
oTrimestre 
oAño 
oIndicador de fin de semana 
•Cálculo de indicadores en la tabla de hechos: Durante la carga de la tabla de hechos se calcularon valores derivados como días de préstamo, penalización y cantidad 
 de préstamos.
Carga de datos: Finalmente, los datos transformados fueron cargados en las tablas del Data Warehouse siguiendo el modelo estrella.
Dimensiones:
•DIM_TIEMPO 
•DIM_USUARIOS 
•DIM_LIBROS 
•DIM_AUTORES 
•DIM_CATEGORIAS
Tabla de hechos:
•HECHOS_PRESTAMOS
7.1 Implementación del procedimiento ETL
Para automatizar el proceso ETL se implementó el procedimiento almacenado SP_ETL_BIBLIOTECA_DW en Oracle, encargado de limpiar las tablas del Data Warehouse, ejecutar 
la carga de dimensiones y posteriormente cargar la tabla de hechos.
8. Diseño de un Data Warehouse (esquema estrella).
El Data Warehouse del Sistema de Biblioteca Digital fue diseñado utilizando un modelo dimensional basado en un esquema estrella. Este modelo permite organizar la 
información de manera eficiente para realizar consultas analíticas, facilitando la generación de reportes sobre préstamos, usuarios, libros y categorías.
•HECHOS_PRESTAMOS: La tabla de hechos almacena las transacciones de préstamos realizadas en la biblioteca. Contiene las claves relacionadas con las dimensiones y las 
 métricas utilizadas para el análisis. 
•DIM_TIEMPO: Permite analizar los préstamos según períodos de tiempo, facilitando reportes por día, mes, trimestre y año.
•DIM_USUARIOS: Contiene la información de los usuarios que realizan préstamos, permitiendo analizar el comportamiento de los usuarios dentro del sistema.
•DIM_LIBROS: Almacena la información descriptiva de los libros disponibles en la biblioteca.
•DIM_AUTORES: Contiene la información de los autores asociados a los libros registrados.
•DIM_CATEGORIAS: Permite clasificar los libros por categorías para realizar análisis sobre las áreas con mayor demanda.
9. Vistas Materializadas
•Libros más prestados: Almacenar el total de préstamos realizados por cada libro para acelerar la generación de reportes relacionados con la demanda de material 
bibliográfico.
•Préstamos por mes: Almacenar el total de préstamos agrupados por mes y año, facilitando el análisis de la evolución del uso de la biblioteca a lo largo del tiempo.
10. Estrategia de Backup y Recovery
Con el fin de garantizar la disponibilidad e integridad de la información almacenada en el Data Warehouse de la Biblioteca Digital, se definió una estrategia de 
respaldo y recuperación que permite minimizar la pérdida de datos ante fallos del sistema, errores humanos o problemas de hardware.
Tipo de respaldo		Frecuencia			Objetivo
Backup completo			Semanal				Respaldar toda la base de datos del Data Warehouse.
Backup incremental		Diario	Respaldar 		únicamente los cambios realizados desde el último respaldo.
Exportación lógica (Data Pump)	Antes de cambiosimportantes	Generar una copia de seguridad de las tablas y objetos del Data Warehouse.
Recovery
En caso de pérdida de información se propone el siguiente procedimiento:
1.Restaurar el último backup completo. 
2.Aplicar el backup incremental más reciente. 
3.Verificar la integridad de las tablas del Data Warehouse. 
4.Ejecutar nuevamente el procedimiento SP_ETL_BIBLIOTECA_DW en caso de ser necesario para reconstruir la información analítica.
11. Integración con MongoDB
Se utilizó MongoDB para almacenar los comentarios realizados por los usuarios sobre los libros registrados en el sistema. La información principal de usuarios y 
libros permanece en la base de datos relacional Oracle, mientras que MongoDB almacena los comentarios y calificaciones en formato documental (JSON). Esta integración 
aprovecha la flexibilidad de las bases de datos NoSQL para gestionar información no estructurada sin afectar el rendimiento de la base de datos transaccional.
12. Conclusión 
El desarrollo del Data Warehouse para el Sistema de Biblioteca Digital permitió consolidar la información proveniente de la base de datos transaccional en una 
estructura orientada al análisis y la toma de decisiones. Mediante la implementación del proceso ETL se realizó la extracción, transformación y carga de los datos 
hacia un esquema estrella conformado por una tabla de hechos y sus respectivas dimensiones. Además, se implementaron vistas materializadas para optimizar las 
consultas más frecuentes, una estrategia de Backup y Recovery para garantizar la disponibilidad e integridad de la información, y una integración con MongoDB para 
almacenar información analítica en formato documental. En conjunto, estas herramientas fortalecen la gestión de la información, mejoran el rendimiento de los análisis 
y demuestran la aplicación de tecnologías tanto relacionales como NoSQL en una solución orientada al soporte de decisiones.
