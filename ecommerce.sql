create table public.customer (
	id SERIAL primary key,
	name varchar(100) not null,
	phone_number varchar(22),
	address text,
	city varchar(100),
	postal_code varchar(10),
	province varchar(100),
	country varchar(100)
);

create table public.seller (
	id SERIAL primary key,
	name varchar(100) not null
);

create table public.product (
	id SERIAL primary key,
	name varchar(255) not null,
	weight decimal(10, 2), 
	price decimal(15, 2) not null,
	seller_id bigint,
	foreign key (seller_id) references Seller(id)
);

create table public.customer_order (
    id SERIAL primary key,
    customer_id bigint NOT NULL,
    order_date date,
    total_price decimal(15, 2) NOT NULL,
    shipping_cost decimal(15, 2),
    insurance_cost decimal(15, 2),
    service_fee decimal(15, 2),
    application_fee decimal(15, 2),
    foreign key (customer_id) references Customer(id)
);

create table public.order_item (
	id SERIAL primary key,
	customer_order_id bigint not null,
	product_id bigint not null,
	quantity int not null,
	unit_price decimal(15, 2) not null,
	total_price decimal(15, 2) not null,
	foreign key (customer_order_id) references customer_order(id),
	foreign key (product_id) references product(id)
);

create table public.payment (
	id SERIAL primary key,
	customer_order_id bigint not null,
	payment_method varchar(50) not null,
	payment_date date,
	total_amount decimal(15, 2) not null,
	foreign key (customer_order_id) references customer_order(id)
);

create table public.shipping (
	id SERIAL primary key,
	customer_order_id bigint not null,
	shipping_method varchar(50),
	shipping_cost decimal(15, 2),
	courrier varchar(50),
	tracking_number varchar(50),
	foreign key (customer_order_id) references customer_order(id)
);

create table public.promotion (
	id SERIAL primary key,
	promo_code varchar(50) unique not null,
	dicsount_amount decimal(15, 2),
	dicsount_percentage decimal(5, 2),
	valid_from date,
	valid_until date
);

create table public.order_promotion (
	id SERIAL primary key,
	customer_oder_id bigint not null,
	promotion_id bigint not null,
	foreign key (customer_oder_id) references customer_order(id),
	foreign key (promotion_id) references promotion(id)
);

-- INSERT customer data
insert into customer (name, phone_number, address, city, postal_code, province, country)
values ('Sum Ting Wong', '6281312341234', 'Digital Park, Sambau, Kecamatan Nongsa', 'Batam', '29466', 'Kepulauan Riau', 'Indonesia');

-- INSERT seller data
insert into seller (name)
values ('COC Komputer');

-- INSERT product data
insert into product (name, weight, price, seller_id)
values ('SAPPHIRE NITRO+ Radeon RX 7900 XTX 24GB', 5.0, 20500000, 1);

-- INSERT customer_order data
insert into customer_order (customer_id, order_date, total_price, shipping_cost, insurance_cost, service_fee, application_fee)
values (1, '2024-05-22', 20685000, 126000, 57700, 1000, 1000);

-- INSERT order_item data
insert into order_item (customer_order_id, product_id, quantity, unit_price, total_price)
values (1,1,1,20500000,20500000);

-- INSERT payment data
insert into payment (customer_order_id, payment_method, payment_date, total_amount)
values (1, 'BCA Virtual Account, GoPay Coins', '2024-05-29', 20500000);

-- INSERT shipping data
insert into shipping (customer_order_id, shipping_method, shipping_cost, courrier, tracking_number)
values (1, 'J&T - Regular', 126000, 'J&T', 'TRACKING123456');

-- INSERT promotion data
insert into promotion (promo_code, dicsount_amount, valid_from, valid_until)
values ('DDDT845', 986385, '2024-01-01', '2024-12-31');

-- Applying promotion into the customer order
insert into order_promotion (customer_oder_id, promotion_id)
values (1,1);

SELECT 
    c.name AS customer_name,
    c.phone_number,
    c.address,
    c.city,
    c.postal_code,
    c.province,
    c.country,
    
    co.order_date,
    co.total_price AS order_total,
    co.shipping_cost,
    co.insurance_cost,
    co.service_fee,
    co.application_fee,
    
    s.name AS seller_name,
    
    p.name AS product_name,
    p.weight,
    p.price AS unit_price,
    
    oi.quantity,
    oi.unit_price,
    oi.total_price AS item_total,
    
    pay.payment_method,
    pay.payment_date,
    pay.total_amount AS paid_amount,
    
    ship.shipping_method,
    ship.courrier,
    ship.tracking_number,
    
    promo.promo_code,
    promo.dicsount_amount,
    promo.valid_from AS promo_start,
    promo.valid_until AS promo_end
    
FROM 
    customer_order co
JOIN customer c ON co.customer_id = c.id
JOIN order_item oi ON co.id = oi.customer_order_id
JOIN product p ON oi.product_id = p.id
JOIN seller s ON p.seller_id = s.id
JOIN payment pay ON co.id = pay.customer_order_id
JOIN shipping ship ON co.id = ship.customer_order_id
LEFT JOIN order_promotion op ON co.id = op.customer_oder_id
LEFT JOIN promotion promo ON op.promotion_id = promo.id
WHERE 
    co.id = 1;





