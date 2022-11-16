CREATE TABLE customers (
	id_customer NVARCHAR(50)PRIMARY KEY,
	EMAIL NVARCHAR(50) NOT NULL,
	NOMBRE NVARCHAR(50) NOT NULL,
	APELLIDO NVARCHAR(50) NOT NULL,
	SEXO NVARCHAR(1) NOT NULL,
	DIRECCION NVARCHAR(100) NULL,
	FECHA_DE_NACIMIENTO DATE NULL,
	TELEFONO NVARCHAR (14) NULL
);


CREATE TABLE items (
	id_items NVARCHAR (50) PRIMARY KEY,
	PRODUCTO NVARCHAR(100) NOT NULL,
	ESTADO NVARCHAR (50) NOT NULL,
	PRECIO INT NOT NULL,
	MEDIDAS INT NOT NULL,
	STOCK INT NOT NULL,
	ID_VENDEDOR INT NOT NULL,
	Fecha_Venta DATE NULL
);
 
CREATE TABLE categories (
	id_categories NVARCHAR (50) PRIMARY KEY,
	NOMBRE VARCHAR(50) NOT NULL
); 


CREATE TABLE orders (
	id_order NVARCHAR (50) PRIMARY KEY,
	id_items NVARCHAR (50) foreign key references items (id_items),
	id_customer NVARCHAR (50) foreign key references customers (id_customer),
	CREADO DATE NULL
);

CREATE TABLE estado (
 	id_estado NVARCHAR (50) PRIMARY KEY,
	id_items NVARCHAR (50),
	PRODUCTO NVARCHAR (50), 
	MONTO INT, 
	ESTADO NVARCHAR (50) 
);

 CREATE TABLE items_estado (
	id_estado NVARCHAR (50),
	id_items NVARCHAR (50),
		primary key(id_estado, id_items),
		foreign key (id_items) references items (id_items),
		foreign key (id_estado) references estado (id_estado)
);

 CREATE TABLE order_items_customer (
	id_items NVARCHAR (50),
	id_customer NVARCHAR (50),
		primary key(id_items, id_customer),
		foreign key (id_items) references items (id_items),
		foreign key (id_customer) references customers (id_customer)
);

 CREATE TABLE items_categories (
	id_categories NVARCHAR (50),
	id_items NVARCHAR (50),
		primary key(id_categories, id_items),
		foreign key (id_categories) references categories (id_categories),
		foreign key (id_items) references items (id_items)
)