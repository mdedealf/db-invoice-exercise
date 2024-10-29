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

create table public.invoice (
    id serial primary key not null ,
    invoice_code varchar(50) unique not null ,

    customer_id bigint not null ,
    seller_id bigint not null ,
    customer_order_id bigint not null ,
    payment_id bigint not null ,
    shipping_id bigint not null ,
    promotion_id bigint,

    total_product_price decimal(15, 2) not null ,
    total_discount decimal(15, 2) default 0.00 ,
    total_payment decimal(15, 2) not null ,
    
    issue_date date not null default current_date,
    
    foreign key (customer_id) references customer(id),
    foreign key (seller_id) references seller(id),
    foreign key (customer_order_id) references customer_order(id),
    foreign key (payment_id) references payment(id),
    foreign key (shipping_id) references shipping(id),
    foreign key (promotion_id) references promotion(id)
);

-- SQL Query to generate invoice
SELECT
    i.invoice_code AS "Invoice Code",

    -- Seller Information
    s.name AS "Seller Name",

    -- Customer (Buyer) Information
    c.name AS "Buyer Name",
    c.phone_number AS "Phone Number",
    CONCAT(
        c.address, ', ',
        c.city, ', ',
        c.province, ', ',
        c.postal_code, ', ',
        c.country
    ) AS "Buyer Address",
    co.order_date AS "Purchase Date",

    -- Product Information
    p.name AS "Product Name",
    p.weight AS "Product Weight",
    oi.quantity AS "Product Quantity",
    oi.unit_price AS "Product Unit Price",
    oi.total_price AS "Total Product Price",

    -- Cost Details
    co.shipping_cost AS "Shipping Cost",
    co.insurance_cost AS "Insurance Cost",
    co.service_fee AS "Service Fee",
    co.application_fee AS "Application Fee",
    i.total_product_price AS "Total Product Price",
    i.total_discount AS "Discount Amount",
    i.total_payment AS "Total Payment",

    -- Promotion Information
    prm.promo_code AS "Promo Code",
    prm.dicsount_amount AS "Promotion Amount",

    -- Shipping Information
    shp.shipping_method AS "Shipping Method",
    shp.carrier AS "Courier",
    shp.tracking_number AS "Tracking Number",

    -- Payment Information
    pmt.payment_method AS "Payment Method",
    pmt.payment_date AS "Payment Date",

    -- Invoice Metadata
    i.issue_date AS "Invoice Issue Date"

FROM
    public.invoice i
    JOIN public.customer c ON i.customer_id = c.id
    JOIN public.seller s ON i.seller_id = s.id
    JOIN public.customer_order co ON i.customer_order_id = co.id
    JOIN public.order_item oi ON co.id = oi.customer_order_id
    JOIN public.product p ON oi.product_id = p.id
    JOIN public.payment pmt ON i.payment_id = pmt.id
    JOIN public.shipping shp ON i.shipping_id = shp.id
    LEFT JOIN public.promotion prm ON i.promotion_id = prm.id

WHERE
    i.invoice_code = 'INV/20330111/MPL/3694336524';


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





