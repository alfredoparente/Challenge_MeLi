/*A resolver*/ 
/*1. Listar los usuarios que cumplan años el día de hoy cuya cantidad de ventas realizadas en enero 2020 sea superior a 1500.*/

SELECT * 
FROM customers C
JOIN orders O ON C.id_customer = O.id_customer
WHERE C.FECHA_DE_NACIMIENTO = GETDATE()
 AND C.id_customer IN	(	SELECT Tabla_Sumarizada.id_customer
							FROM	(	SELECT SUM (O.id_customer) as Suma_Usuario,
												O.id_customer AS ID_CUSTOMER 
													FROM customers C 
														JOIN orders O ON C.id_customer = O.id_customer
													WHERE CAST (YEAR (O.CREADO) AS VARCHAR) + CAST(MONTH(O.CREADO) AS VARCHAR) = '20201'
													GROUP BY O.id_customer
													ORDER BY Suma_Usuario ASC
									) Tabla_Sumarizada
							WHERE Tabla_Sumarizada.Suma_Usuario > 1500
						)



/*2. Por cada mes del 2020, se solicita el top 5 de usuarios que más vendieron ($) en la categoría Celulares. 
Se requiere el mes y año de análisis, nombre y apellido del vendedor, cantidad de ventas realizadas, cantidad de productos vendidos 
y el monto total transaccionado.*/

SELECT	MONTH (O.CREADO) MES,
		YEAR (O.CREADO) AÑO,
		C.NOMBRE NOMBRE,
		C.APELLIDO AS APELLIDO,
		TOP_USUARIOS.TOTAL_VENTAS AS TOTAL_VENTAS,
		TOP_USUARIOS.TOTAL_PRECIO AS TOTAL_PRECIO
	FROM customers C
		JOIN orders O ON C.id_customer = O.id_customer
	JOIN	(
			SELECT TOP 5 COUNT(items.id_items) AS TOTAL_VENTAS,
					SUM(items.PRECIO) AS TOTAL_PRECIO,
					C.id_customer AS ID_CUSTOMER 
				FROM customers C
					JOIN orders O ON O.id_customer = C.id_customer
					JOIN items ON items.id_items = O.id_items
					JOIN categories CAT	ON CAT.id_categories = items.id_items
				WHERE CAT.NOMBRE LIKE 'CELULARES'
				GROUP BY CAST(YEAR(O.CREADO) AS VARCHAR)+CAST(MONTH(O.CREADO) AS VARCHAR), C.id_customer
				ORDER BY C.id_customer ASC 
			) TOP_USUARIOS
  ON C.id_customer = TOP_USUARIOS.ID_CUSTOMER
  ;



/*3. Se solicita poblar una nueva tabla con el precio y estado de los Ítems a fin del día. 
Tener en cuenta que debe ser reprocesable. Vale resaltar que en la tabla Item, 
vamos a tener únicamente el último estado informado por la PK definida. (Se puede resolver a través de StoredProcedure)*/


GO

CREATE PROCEDURE TABLA_PRECIO_ESTADO_ITEMS
@DIA DATETIME

 AS

	INSERT INTO estado
		SELECT	estado.id_estado,
				items.id_items,	
				items.PRODUCTO,
				estado.MONTO AS MONTO, 
				'CERRADO' AS ESTADO 
		  FROM items
			JOIN orders ON orders.id_items = orders.id_items
			JOIN estado ON estado.id_items = orders.id_items
			JOIN items_estado ON items.id_items = items_estado.id_items
		 WHERE orders.CREADO = @DIA
	UNION
		SELECT	estado.id_estado,
				items.id_items, 
				items.PRODUCTO, 
				estado.MONTO AS MONTO, 
				'CERRADO' AS ESTADO 
		  FROM items
			JOIN orders ON items.id_items = orders.id_items
			JOIN estado ON estado.id_items = orders.id_items
			JOIN items_estado ON items.id_items = items_estado.id_items
		 WHERE items_estado.id_items IS NULL
		   AND orders.id_items IS NULL
