#--------------------------------------------------------
--  DDL for schema ESHOP
#--------------------------------------------------------
drop schema if exists eshop;
create schema if not exists eshop;

#--------------------------------------------------------
--  DDL for Table CATEGORY
#--------------------------------------------------------
drop table if exists eshop.categories;
create table if not exists eshop.categories
(
    id     int         not null auto_increment,
    name   varchar(45) not null,
    rating double      not null,
    primary key (id),
    unique index idx_categories_category_id_unique (id asc),
    unique index idx_categories_name_unique (name asc)
);
#--------------------------------------------------------
--  DDL for Table PRODUCTS
#--------------------------------------------------------
drop table if exists eshop.products;
create table if not exists eshop.products
(
    id          int            not null auto_increment,
    name        varchar(200)   not null,
    description varchar(400)   not null,
    price       decimal(10, 2) not null,
    category_id int            not null,
    primary key (id),
    unique index idx_products_id_unique (id asc),
    unique index idx_name_unique (name asc),
    constraint fk_products_category_id_categories_id
        foreign key (category_id) references eshop.categories (id)
            on delete cascade
            on update cascade
);
#--------------------------------------------------------
--  DDL for Table USERS
#--------------------------------------------------------
drop table if exists eshop.users;
create table if not exists eshop.users
(
    id            int          not null auto_increment,
    login         varchar(50)  not null,
    name          varchar(100) not null,
    surname       varchar(200) not null,
    password      varchar(100) not null,
    date_of_birth date         not null,
    email         varchar(100) not null,
    balance       decimal(10, 2),
    primary key (id),
    unique index idx_users_user_id_unique (id asc),
    unique index idx_users_login_unique (login asc)
);
#--------------------------------------------------------
--  DDL for Table ORDERS
#--------------------------------------------------------
drop table if exists eshop.orders;
create table if not exists eshop.orders
(
    id      int            not null auto_increment,
    price   decimal(10, 2) not null,
    date    datetime       not null,
    user_id int            not null,
    primary key (id),
    unique index idx_orders_id_unique (id asc),
    constraint fk_orders_user_id_users_id
        foreign key (user_id) references eshop.users (id)
            on delete cascade
            on update cascade
);
#--------------------------------------------------------
--  DDL for Table PRODUCT_IMAGES
#--------------------------------------------------------
drop table if exists eshop.images;
create table if not exists eshop.images
(
    id           int          not null auto_increment,
    category_id  int,
    product_id   int,
    primary_flag boolean      not null,
    image_path   varchar(200) not null,
    primary key (id),
    constraint fk_images_category_id_categories_id
        foreign key (category_id) references eshop.categories (id)
            on delete cascade
            on update cascade,
    constraint fk_images_product_id_products_id
        foreign key (product_id) references eshop.products (id)
            on delete cascade
            on update cascade
);
#--------------------------------------------------------
--  DDL for Table ORDER_PRODUCTS
#--------------------------------------------------------
drop table if exists eshop.order_products;
create table if not exists eshop.order_products
(
    order_id   int not null,
    product_id int not null,
    quantity   int not null,
    primary key (order_id, product_id),
    constraint fk_order_products_order_id_orders_id
        foreign key (order_id)
            references orders (id)
            on delete cascade
            on update cascade,
    constraint fk_order_products_product_id_products_id
        foreign key (product_id)
            references products (id)
            on delete cascade
            on update cascade
);
#--------------------------------------------------------
--  DDL for Table ROLES
#--------------------------------------------------------
drop table if exists eshop.roles;
create table if not exists eshop.roles
(
    id   int         not null auto_increment,
    name varchar(45) not null,
    primary key (id),
    unique index idx_roles_role_id_unique (id asc),
    unique index idx_roles_name_unique (name asc)
);
#--------------------------------------------------------
--  DDL for Table USERS_ROLES
#--------------------------------------------------------
drop table if exists eshop.user_roles;
create table if not exists eshop.user_roles
(
    user_id int not null,
    role_id int not null,
    primary key (user_id, role_id),
    constraint fk_user_products_user_id_users_id
        foreign key (user_id)
            references users (id)
            on delete cascade
            on update cascade,
    constraint fk_user_roles_role_id_roles_id
        foreign key (role_id)
            references roles (id)
            on delete cascade
            on update cascade
);
#--------------------------------------------------------
--  DML for Table ESHOP.CATEGORIES
#--------------------------------------------------------
insert into eshop.categories (id, name, rating)
values (1, 'Мобильные телефоны', 5);
insert into eshop.categories (id, name, rating)
values (2, 'Ноутбуки', 5);
insert into eshop.categories (id, name, rating)
values (3, 'GPS навигаторы', 5);
insert into eshop.categories (id, name, rating)
values (4, 'Холодильники', 5);
insert into eshop.categories (id, name, rating)
values (5, 'Телевизоры', 5);
insert into eshop.categories (id, name, rating)
values (6, 'Фотоаппараты', 5);
insert into eshop.categories (id, name, rating)
values (7, 'Кондиционеры', 5);
insert into eshop.categories (id, name, rating)
values (8, 'Автомобили', 5);
insert into eshop.categories (id, name, rating)
values (9, 'Посудомоечные машины', 5);
insert into eshop.categories (id, name, rating)
values (10, 'Обогреватели', 5);
insert into eshop.categories (id, name, rating)
values (11, 'Вытяжки', 5);
insert into eshop.categories (id, name, rating)
values (12, 'Утюги', 5);
insert into eshop.categories (id, name, rating)
values (13, 'Микроволновые печи', 5);
insert into eshop.categories (id, name, rating)
values (14, 'Самокаты', 5);
insert into eshop.categories (id, name, rating)
values (15, 'Пылесосы', 5);
insert into eshop.categories (id, name, rating)
values (16, 'Стиральные машины', 5);
insert into eshop.categories (id, name, rating)
values (17, 'Часы', 5);
insert into eshop.categories (id, name, rating)
values (18, 'Наушники', 5);
#--------------------------------------------------------
--  DML for Table ESHOP.PRODUCTS
#--------------------------------------------------------
insert into eshop.products (id, name, description, price, category_id)
values (1, 'Смартфон Apple iPhone 13 128GB Midnight (MLNW3RK/A)',
        'Экран: 6.1" 1170x2532 пикселей, OLED; Процессор: Apple A15 Bionic; Память: ОЗУ 4 ГБ , 128 ГБ; Формат SIM-карты: Nano + eSIM; Количество мегапикселей камеры: 12 Мп',
        2600, 1);
insert into eshop.products (id, name, description, price, category_id)
values (2, 'Смартфон Nokia G21 (TA-1418) DS 4/128GB Blue',
        'Экран: 6.5" 720x1600 пикселей, IPS; Процессор: UniSoC T606 1.6 ГГц; Память: ОЗУ 4 ГБ, 128 ГБ; Формат SIM-карты: Nano; Количество мегапикселей камеры: 50 Мп; Емкость аккумулятора: 5000 мА·ч',
        499, 1);
insert into eshop.products (id, name, description, price, category_id)
values (3, 'Смартфон Xiaomi 12 Lite 8GB/256GB Black',
        'Экран: 6.55" 1080x2400 пикселей, AMOLED; Процессор: Qualcomm Snapdragon 778G 2.4 ГГц; Память: ОЗУ 8 ГБ, 256 ГБ; Формат SIM-карты: Nano; Количество мегапикселей камеры: 108 Мп; Емкость аккумулятора: 4300 мА·ч',
        1499, 1);
insert into eshop.products (id, name, description, price, category_id)
values (4, 'Смартфон Samsung Galaxy A32 4GB/128GB (фиолетовый)',
        'Экран: 6.4" 1080x2400 пикселей, AMOLED (Super AMOLED Plus); Процессор: MediaTek Helio G80 2 ГГц; Память: ОЗУ 4 ГБ, 128 ГБ; Формат SIM-карты: Nano; Количество мегапикселей камеры: 64 Мп; Емкость аккумулятора: 5000 мА·ч',
        899, 1);
insert into eshop.products (id, name, description, price, category_id)
values (5, 'Смартфон Xiaomi Redmi Note 11 Pro 5G 8GB/128GB Atlantic Blue',
        'Экран: 6.67" 1080x2400 пикселей, AMOLED; Процессор: Qualcomm Snapdragon 695 2.2 ГГц; Память: ОЗУ 8 ГБ, 128 ГБ; Формат SIM-карты: Nano; Количество мегапикселей камеры: 108 Мп; Емкость аккумулятора: 5000 мА·ч',
        1049, 1);
insert into eshop.products (id, name, description, price, category_id)
values (6, 'Смартфон Huawei P50 ABR-LX9 8GB/256GB (черный)',
        'Экран: 6.5" 1224х2700 пикселей, OLED; Процессор: Qualcomm Snapdragon 888 2.84 ГГц; Память: ОЗУ 8 ГБ, 256 ГБ; Формат SIM-карты: Nano; Количество мегапикселей камеры: 50 Мп; Емкость аккумулятора: 4100 мА·ч',
        1999, 1);
insert into eshop.products (id, name, description, price, category_id)
values (7, 'Смартфон POCO F3 8GB/256GB Night Black',
        'Экран: 6.67" 1080x2400 пикселей, AMOLED; Процессор: Qualcomm Snapdragon 870 3.2 ГГц; Память: ОЗУ 8 ГБ, 256 ГБ; Формат SIM-карты: Nano; Количество мегапикселей камеры: 48 Мп; Емкость аккумулятора: 4520 мА·ч',
        1399, 1);
insert into eshop.products (id, name, description, price, category_id)
values (8, 'Смартфон Huawei P50 Pocket Premium Gold (BAL-L49)',
        'Экран: 6.9" 1188х2790 пикселей, OLED; Процессор: Qualcomm Snapdragon 888 2.84 ГГц; Память: ОЗУ 12 ГБ, 512 ГБ; Формат SIM-карты: Nano; Количество мегапикселей камеры: 40 Мп; Емкость аккумулятора: 4000 мА·ч',
        4499, 1);
insert into eshop.products (id, name, description, price, category_id)
values (9, 'Смартфон VIVO Y21 4GB/64GB (бриллиантовое сияние)',
        'Экран: 6.51" 720x1600 пикселей, IPS; Процессор: MediaTek Helio P35 2.3 ГГц; Память: ОЗУ 4 ГБ, 64 ГБ; Формат SIM-карты: Nano; Количество мегапикселей камеры: 13 Мп; Емкость аккумулятора: 5000 мА·ч',
        399, 1);
insert into eshop.products (id, name, description, price, category_id)
values (10, 'Смартфон Samsung Galaxy S22 Ultra 12GB/256GB (SM-S908BDRGCAU)',
        'Экран: 6.8 " 1440x3088 пикселей, Dynamic AMOLED 2X; Процессор: Exynos 2200 2.8 ГГц; Память: ОЗУ 12 ГБ, 256 ГБ; Формат SIM-карты: Nano; Количество мегапикселей камеры: 108 Мп; Емкость аккумулятора: 5000 мА·ч',
        5099, 1);

insert into eshop.products (id, name, description, price, category_id)
values (11, 'Ноутбук Acer Nitro 5 AN517-54-507Y (NH.QF6EU.004)',
        'Экран:  17.3" 1920x1080 px, IPS 144 Гц; Процессор: Intel Core-i5 11400H 6 -ядерный, 2.7 ГГц - 4.5 ГГц, Tiger Lake; Видеокарта: Дискретная NVIDIA GeForce RTX 3050 Ti 4 ГБ GDDR6; Память: ОЗУ 16 ГБ DDR4, SSD 512 ГБ; Вес и габариты: 2.2 кг, 403.5 мм х 280 мм х 24.9 мм',
        4897, 2);
insert into eshop.products (id, name, description, price, category_id)
values (12, 'Ноутбук Asus TUF Gaming F15 FX506HCB-HN1138',
        'Экран: 15.6" 1920x1080 px, IPS 144 Гц; Процессор: Intel Core-i5 11400H 6 -ядерный, 2.7 ГГц - 4.5 ГГц, Tiger Lake; Видеокарта: Дискретная NVIDIA GeForce RTX 3050 4 ГБ GDDR6; Память: ОЗУ 8 ГБ DDR4, SSD 512 ГБ; Вес и габариты: 2 кг, 360 мм х 252 мм х 19.9 мм',
        3904, 2);
insert into eshop.products (id, name, description, price, category_id)
values (13, 'Ноутбук HP Victus 16-e0504nw (4H3L7EA)',
        'Экран: 16.1" 1920x1080 px, IPS 144 Гц; Процессор: AMD Ryzen 7 5800H 8 -ядерный, 3.2 ГГц - 4.4 ГГц, Cezanne; Видеокарта: Дискретная NVIDIA GeForce RTX 3060 6 ГБ; Память: ОЗУ 16 ГБ DDR4, SSD 512 ГБ; Вес и габариты: 2.46 кг, 370 мм х 260 мм х 23.5 мм',
        4320, 2);
insert into eshop.products (id, name, description, price, category_id)
values (14, 'Ноутбук Lenovo IdeaPad 5 15ALC05 82LN00T5RE',
        'Экран: 15.6" 1920x1080 px, IPS 60 Гц; Процессор: AMD Ryzen 5 5500U 6 -ядерный, 2.1 ГГц - 4.0 ГГц, Lucienne; Видеокарта: Встроенная AMD Radeon Graphics; Память: ОЗУ 16 ГБ DDR4, SSD 256 ГБ; Вес и габариты: 1.66 кг, 356.67 мм х 233.13 мм х 17.9-19.9 мм',
        2655, 2);
insert into eshop.products (id, name, description, price, category_id)
values (15, 'Ноутбук Asus ROG Zephyrus G15 GA502IU-AL051',
        'Экран: 15.6" 1920x1080 px, IPS 144 Гц; Процессор: AMD Ryzen 7 4800HS 8 -ядерный, 2.9 ГГц - 4.2 ГГц, Renoir; Видеокарта: Дискретная NVIDIA GeForce GTX 1660 Ti 6 ГБ GDDR6; Память: ОЗУ 8 ГБ DDR4, SSD 512 ГБ; Вес и габариты: 2.1 кг, 360 мм х 252 мм х 20.4 мм',
        4229, 2);
insert into eshop.products (id, name, description, price, category_id)
values (16, 'Ноутбук MSI Katana GF76 11UD-820XBY',
        'Экран: 17.3" 1920x1080 px, IPS 144 ГцжПроцессор: Intel Core-i5 11400H 6 -ядерный, 2.7 ГГц - 4.5 ГГц, Tiger Lake; Видеокарта: Дискретная NVIDIA GeForce RTX 3050 Ti 4 ГБ; Память: ОЗУ 16 ГБ DDR4, SSD 512 ГБ; Вес и габариты: 2.6 кг, 398 мм х 273 мм х 25.2 мм',
        5275, 2);
insert into eshop.products (id, name, description, price, category_id)
values (17, 'Ноутбук Lenovo Legion 5 Pro 16ITH6H 82JD003TRK',
        'Экран: 16.0" 2560x1600 px, IPS 165 Гц; Процессор: Intel Core-i7 11800H 8 -ядерный, 2.3 ГГц - 4.6 ГГц, Tiger Lake; Видеокарта: Дискретная NVIDIA GeForce RTX 3060 6 ГБ GDDR6; Память: ОЗУ 16 ГБ DDR4, SSD 1024 ГБ; Вес и габариты: 2.3 кг, 356 мм х 260.2-264.2 мм х 21.7-26.15 мм',
        7555, 2);
insert into eshop.products (id, name, description, price, category_id)
values (18, 'Ноутбук Dell G15 5515-378844',
        'Экран: 15.6 " 1920x1080 px, IPS 120 Гц; Процессор: AMD Ryzen 7 5800H 8 -ядерный, 3.2 ГГц - 4.4 ГГц, Cezanne; Видеокарта: Дискретная NVIDIA GeForce RTX 3050 4 ГБ GDDR6; Память: ОЗУ 16 ГБ DDR4, SSD 512 ГБ; Версия операционной системы: Windows 11 Pro; Вес и габариты: 2.81 кг, 357.3 мм х 272.1 мм х 24.9 мм',
        4896, 2);
insert into eshop.products (id, name, description, price, category_id)
values (19, 'Ноутбук Dell Alienware m15 R5 M15-379065',
        'Экран: 15.6" 1920x1080 px 165 Гц; Процессор: AMD Ryzen 7 5800H 8 -ядерный, 3.2 ГГц - 4.4 ГГц, Cezanne; Видеокарта: Дискретная NVIDIA GeForce RTX 3050 Ti 4 ГБ GDDR6; Память: ОЗУ 16 ГБ DDR4, SSD 512 ГБ; Версия операционной системы: Windows 11 Pro; Вес и габариты: 2.69 кг, 356.2 мм х 272.5 мм х 19.2 мм',
        6507, 2);
insert into eshop.products (id, name, description, price, category_id)
values (20, 'Ноутбук Apple MacBook Pro 14" M1 Pro 2021 (Z15G000CN) серый космос',
        'Экран: 14.2" 3024х1964 px, IPS 120 Гц; Процессор: Apple M1 M1 Pro 10 , Apple Silicon; Видеокарта: Встроенная Apple M1 Pro GPU (16 ядер); Память: ОЗУ 16 ГБ, SSD 512 ГБ; Версия операционной системы: Mac OS (Monterey); Вес и габариты: 1.61 кг, 312.6 мм х 221.2 мм х 15.5 мм',
        6990, 2);

insert into eshop.products (id, name, description, price, category_id)
values (21, 'GPS навигатор Navitel N500 Magnetic',
        'Тип: Портативный; Программное обеспечение: Navitel; Размер экрана:  5"; Сенсорный экран: Да; Навигация: Возможность загрузки карты местности, Голосовые сообщения',
        249, 3);
insert into eshop.products (id, name, description, price, category_id)
values (22, 'GPS навигатор NAVITEL T737 PRO с ПО Navitel Navigator (СНГ + Европа)',
        'Тип: Портативный; Программное обеспечение: Navitel; Размер экрана: 7"; Сенсорный экран: Да; Навигация: Возможность загрузки карты местности, Голосовые сообщения, Загрузка пробок, GPS',
        338, 3);
insert into eshop.products (id, name, description, price, category_id)
values (23, 'GPS навигатор Prestigio GeoVision 5068 ProGorod (PGPS5068CIS04GBPG)',
        'Тип: Портативный; Программное обеспечение: Navitel; Размер экрана:  5"; Сенсорный экран: Да; Навигация: Автоматический расчет маршрутов, Поддержка карт местности',
        150, 3);
insert into eshop.products (id, name, description, price, category_id)
values (24, 'GPS навигатор PRESTIGIO PGPS5850 CIS8HDDVRNV',
        'Тип:  Портативный; Программное обеспечение:  Navitel; Размер экрана:  5"; Сенсорный экран: Да; Навигация:  Автоматический расчет маршрутов, Встроенная карта, Календарь, Поддержка карт местности',
        160, 3);
insert into eshop.products (id, name, description, price, category_id)
values (25, 'GPS навигатор PRESTIGIO PGPS7777 CIS8GBNV',
        'Тип: Портативный; Программное обеспечение:  Navitel; Размер экрана:  7"; Сенсорный экран: Да',
        100, 3);
insert into eshop.products (id, name, description, price, category_id)
values (26, 'GPS навигатор Navitel G550 Moto с ПО Navitel Navigator (СНГ + Европа)',
        'Тип: Портативный; Программное обеспечение: Navitel; Размер экрана: 4.3"; Сенсорный экран: Да; Навигация: Автоматический расчет маршрутов, Встроенная карта, Предупреждает о радарах, камерах видеозаписи и лежачих полицейских',
        460, 3);
insert into eshop.products (id, name, description, price, category_id)
values (27, 'GPS навигатор Navitel F150 с ПО Navitel Navigator (РБ,Украина,Польша,Чехия, Словакия)',
        'Тип: Портативный; Программное обеспечение: Navitel; Размер экрана: 5"; Сенсорный экран: Да; Навигация: 3D-карты, База данных объектов POI, Голосовые сообщения',
        159, 3);
insert into eshop.products (id, name, description, price, category_id)
values (28, 'GPS Garmin Drive 51 MPC',
        'Тип: Стационарный; Размер экрана: 5"; Сенсорный экран: Да; Навигация: Возможность загрузки карты местности, Встроенная карта, Предупреждает о радарах, камерах видеозаписи и лежачих полицейских, Голосовые сообщения',
        579, 3);
insert into eshop.products (id, name, description, price, category_id)
values (29, 'GPS навигатор Navitel E500 MAGNETIC',
        'Тип: Портативный; Программное обеспечение: Navitel; Размер экрана: 5"; Сенсорный экран: Да; Навигация: Автоматический расчет маршрутов, Возможность загрузки карты местности, Встроенная карта, Голосовые сообщения',
        259, 3);
insert into eshop.products (id, name, description, price, category_id)
values (30, 'GPS навигатор PRESTIGIO GeoVision Tour 4 Progorod (PGPS7800CIS08GBPG)',
        'Тип: Портативный; Программное обеспечение: ПРОГОРОД; Размер экрана: 7"; Сенсорный экран: Да; Навигация: Автоматический расчет маршрутов, Возможность загрузки карты местности, Голосовые сообщения, Поддержка карт местности, Встроенная карта, Предупреждает о радарах, камерах видеозаписи и лежачих полицейских, 3D-карты, База данных объектов POI',
        179, 3);

insert into eshop.products (id, name, description, price, category_id)
values (31, 'Холодильник Indesit ITR 5200 W',
        'No Frost: Полный; Полезный объем: 325 л, 247 л + 78 л; Цвет: Белый; Тип управления: Электронное; Класс энергопотребления: A; Высота: 196 см',
        1499, 4);
insert into eshop.products (id, name, description, price, category_id)
values (32, 'Холодильник Bosch Serie 4 VitaFresh KGN39XI27R',
        'No Frost: Полный; Полезный объем: 388 л, 280 л + 108 л; Зона свежести: Да; Цвет: Нержавеющая сталь; Тип управления: Электронное; Класс энергопотребления: A+',
        2799, 4);
insert into eshop.products (id, name, description, price, category_id)
values (33, 'Холодильник LG DoorCooling+ GA-B509CMTL',
        'No Frost: Полный; Полезный объем: 384 л, 277 л + 107 л; Зона свежести: Да; Цвет: Серебристый; Тип управления: Электронное; Класс энергопотребления: A+',
        2590, 4);
insert into eshop.products (id, name, description, price, category_id)
values (34, 'Холодильник ATLANT ХМ-4425-000-N',
        'No Frost: Полный; Полезный объем: 314 л, 203 л + 111 л; Цвет: Белый; Тип управления: Электронное; Класс энергопотребления: A; Высота: 206.5 см',
        1493, 4);
insert into eshop.products (id, name, description, price, category_id)
values (35, 'Холодильник SAMSUNG RB33A32N0SA/WT',
        'No Frost: Полный; Полезный объем: 328 л, 230 л + 98 л; Цвет: Серебристый; Тип управления: Электронное; Класс энергопотребления: A+; Высота: 185 см',
        1849, 4);
insert into eshop.products (id, name, description, price, category_id)
values (36, 'Холодильник ATLANT ХМ-6025-582',
        'Полезный объем: 364 л, 225 л + 139 л; Цвет: Серебристый; Тип управления: Механическое; Класс энергопотребления: A+; Высота: 205 см',
        1526, 4);
insert into eshop.products (id, name, description, price, category_id)
values (37, 'Холодильник HAIER HRF-541DM7RU',
        'No Frost: Полный; Полезный объем: 504 л, 337 л + 167 л; Зона свежести: Да; Цвет: Серебристый; Тип управления: Сенсорное; Класс энергопотребления: A+',
        3750, 4);
insert into eshop.products (id, name, description, price, category_id)
values (38, 'Встраиваемый холодильник ATLANT ХМ-4307-000',
        'Полезный объем: 234 л, 167 л + 67 л; Цвет: Белый; Тип управления: Механическое; Класс энергопотребления: A; Высота: 178 см',
        1106, 4);
insert into eshop.products (id, name, description, price, category_id)
values (39, 'Холодильник MAUNFELD MFF177NFSB',
        'No Frost: Полный; Полезный объем: 562 л, 359 л + 203 л; Зона свежести: Да; Цвет: Черный; Тип управления: Электронное; Класс энергопотребления: A++',
        3499, 4);
insert into eshop.products (id, name, description, price, category_id)
values (40, 'Холодильник LG GC-B257JLYV',
        'No Frost: Полный; Полезный объем: 647 л, 414 л + 229 л; Зона свежести: Да; Цвет: Графитовый; Тип управления: Электронное; Класс энергопотребления: A+',
        4999, 4);

insert into eshop.products (id, name, description, price, category_id)
values (41, 'Телевизор LG 50NANO766QA',
        'Smart TV: Да; Тип экрана: NanoCell; Диагональ: 50"; Разрешение: Ultra HD 4K-3840x2160 пикс.; LED-подсветка: Direct LED; Операционная система: WebOS',
        2400, 5);
insert into eshop.products (id, name, description, price, category_id)
values (42, 'Телевизор Samsung UE55AU8000UXRU',
        'Smart TV: Да; Тип экрана: LCD; Диагональ: 55"; Разрешение: Ultra HD 4K-3840x2160 пикс.; LED-подсветка: Edge LED; Операционная система: Tizen',
        2599, 5);
insert into eshop.products (id, name, description, price, category_id)
values (43, 'Телевизор Samsung UE50AU7170UXRU',
        'Smart TV: Да; Тип экрана: LCD; Диагональ: 50"; Разрешение: Ultra HD 4K-3840x2160 пикс.; LED-подсветка: Edge LED; Операционная система: Tizen',
        1999, 5);
insert into eshop.products (id, name, description, price, category_id)
values (44, 'Телевизор LG 43UQ75006LF',
        'Smart TV: Да; Тип экрана: LCD; Диагональ: 43"; Разрешение: Ultra HD 4K-3840x2160 пикс.; LED-подсветка: Direct LED; Операционная система: WebOS',
        1699, 5);
insert into eshop.products (id, name, description, price, category_id)
values (45, 'Телевизор TCL 50P615',
        'Smart TV: Да; Тип экрана: LCD; Диагональ: 50"; Разрешение: Ultra HD 4K-3840x2160 пикс.; LED-подсветка: Direct LED; Операционная система: Android TV',
        1499, 5);
insert into eshop.products (id, name, description, price, category_id)
values (46, 'Телевизор TCL 65P725',
        'Smart TV: Да, Тип экрана: LCD; Диагональ: 65"; Разрешение: Ultra HD 4K-3840x2160 пикс.; LED-подсветка: Direct LED; Операционная система: Android TV',
        2999, 5);
insert into eshop.products (id, name, description, price, category_id)
values (47, 'Телевизор Sony KD-65X85TJ',
        'Smart TV: Да; Тип экрана: LCD; Диагональ: 65"; Разрешение: Ultra HD 4K-3840x2160 пикс.; LED-подсветка: Direct LED; Операционная система: Android TV',
        5926, 5);
insert into eshop.products (id, name, description, price, category_id)
values (48, 'Телевизор KIVI 40F740LB',
        'Smart TV: Да; Тип экрана: LCD; Диагональ: 40"; Разрешение: Full HD-1920x1080 пикс.; LED-подсветка: Direct LED; Операционная система: Android TV',
        1133, 5);
insert into eshop.products (id, name, description, price, category_id)
values (49, 'Телевизор KIVI 32F790LW',
        'Smart TV: Да; Тип экрана: LCD; Диагональ: 32"; Разрешение: Full HD-1920x1080 пикс.; LED-подсветка: Direct LED; Операционная система: Android TV',
        956, 5);
insert into eshop.products (id, name, description, price, category_id)
values (50, 'Телевизор Philips 50PUS7956/60',
        'Smart TV: Да; Тип экрана: LCD; Диагональ: 50"; Разрешение: Ultra HD 4K-3840x2160 пикс.; Операционная система: Android TV',
        2229, 5);

insert into eshop.products (id, name, description, price, category_id)
values (51, 'Зеркальный фотоаппарат Canon EOS 850D Kit 18-55mm f/4-5.6 IS STM',
        'Поворотный экран: Да; Максимальное разрешение видео: 3840x2160; Оптическая стабилизация изображения: Да; Wi-Fi: Да; Bluetooth: Да',
        4499, 6);
insert into eshop.products (id, name, description, price, category_id)
values (52, 'Фотоаппарат Sony ZV-1',
        'Поворотный экран: Да; Максимальное разрешение видео: 3840x2160; Оптическая стабилизация изображения: Да; Wi-Fi: Да; Bluetooth: Да',
        2399, 6);
insert into eshop.products (id, name, description, price, category_id)
values (53, 'Цифровая фотокамера CANON EOS RP RF 24-105 F4-7.1 IS STM (3380C133)',
        'Поворотный экран: Да; Оптический zoom: 4X; Максимальное разрешение видео: 3840x2160; Оптическая стабилизация изображения: Да; Wi-Fi: Да; Bluetooth: Да',
        7999, 6);
insert into eshop.products (id, name, description, price, category_id)
values (54, 'Фотоаппарат Sony ZV-1 PRO',
        'Поворотный экран: Да; Максимальное разрешение видео: 3840x2160; Оптическая стабилизация изображения: Да; Wi-Fi: Да; Bluetooth: Да',
        1449, 6);
insert into eshop.products (id, name, description, price, category_id)
values (55, 'Фотокамера Nikon D3300 комплект с 18-55 VR AF-P Kit черный',
        'Оптический zoom: 3X; Максимальное разрешение видео: 1920x1080 (FullHD); Оптическая стабилизация изображения: Да',
        1399, 6);
insert into eshop.products (id, name, description, price, category_id)
values (56, 'Цифровая фотокамера NIKON COOLPIX B700 Black',
        'Поворотный экран: Да; Оптический zoom: 60X; Максимальное разрешение видео: 3840x2160; Оптическая стабилизация изображения: Да; Wi-Fi: Да; Bluetooth: Да',
        1290, 6);
insert into eshop.products (id, name, description, price, category_id)
values (57, 'Беззеркальный фотоаппарат Canon EOS R Kit RF 24-105mm f/4-7.1 IS STM',
        'Поворотный экран: Да; Оптический zoom: 4.4X; Максимальное разрешение видео: 4096x2160 (Ultra HD); Оптическая стабилизация изображения: Да; Wi-Fi: Да; Bluetooth: Да',
        6799, 6);
insert into eshop.products (id, name, description, price, category_id)
values (58, 'Фотоаппарат Canon EOS R6 Kit RF 24-105mm f/4-7.1 IS STM (4082C023)',
        'Поворотный экран: Да; Максимальное разрешение видео: 3840x2160; Оптическая стабилизация изображения: Да; Wi-Fi: Да; Bluetooth: Да',
        8999, 6);
insert into eshop.products (id, name, description, price, category_id)
values (59, 'Беззеркальный фотоаппарат Canon EOS M6 Mark II M15-45 S + EVF EU26 (черный)',
        'Поворотный экран: Да; Максимальное разрешение видео: 3840x2160; Оптическая стабилизация изображения: Да; Wi-Fi: Да; Bluetooth: Да',
        6199, 6);
insert into eshop.products (id, name, description, price, category_id)
values (60, 'Фотокамера SONY Alpha a5000 Kit 16-50mm (ILCE-5000L)',
        'Поворотный экран: Да; Оптический zoom: 3X; Максимальное разрешение видео: 1920x1080 (FullHD); Оптическая стабилизация изображения: Да; Wi-Fi: Да',
        1499, 6);

#--------------------------------------------------------
--  DML for Table ESHOP.IMAGES (categories)
# --------------------------------------------------------
insert into eshop.images(category_id, primary_flag, image_path)
values (1, 1, 'categoryMobiles.jpg');
insert into eshop.images(category_id, primary_flag, image_path)
values (2, 1, 'categoryLaptops.jpg');
insert into eshop.images(category_id, primary_flag, image_path)
values (3, 1, 'categoryGpsNavigators.jpg');
insert into eshop.images(category_id, primary_flag, image_path)
values (4, 1, 'categoryFridges.jpg');
insert into eshop.images(category_id, primary_flag, image_path)
values (5, 1, 'categoryTV.jpg');
insert into eshop.images(category_id, primary_flag, image_path)
values (6, 1, 'categoryCameras.jpg');
insert into eshop.images(category_id, primary_flag, image_path)
values (7, 1, 'categoryAirConditioners.jpg');
insert into eshop.images(category_id, primary_flag, image_path)
values (8, 1, 'categoryCars.jpg');
insert into eshop.images(category_id, primary_flag, image_path)
values (9, 1, 'categoryDishwashers.jpg');
insert into eshop.images(category_id, primary_flag, image_path)
values (10, 1, 'categoryHeaters.jpg');
insert into eshop.images(category_id, primary_flag, image_path)
values (11, 1, 'categoryHoods.jpg');
insert into eshop.images(category_id, primary_flag, image_path)
values (12, 1, 'categoryIrons.jpg');
insert into eshop.images(category_id, primary_flag, image_path)
values (13, 1, 'categoryMicrowaves.jpg');
insert into eshop.images(category_id, primary_flag, image_path)
values (14, 1, 'categoryScooters.jpg');
insert into eshop.images(category_id, primary_flag, image_path)
values (15, 1, 'categoryVacuumCleaners.jpg');
insert into eshop.images(category_id, primary_flag, image_path)
values (16, 1, 'categoryWashingMachines.jpg');
insert into eshop.images(category_id, primary_flag, image_path)
values (17, 1, 'categoryWatches.jpg');
insert into eshop.images(category_id, primary_flag, image_path)
values (18, 1, 'categoryHeadPhones.jpg');
#--------------------------------------------------------
--  DML for Table ESHOP.IMAGES (products)
# --------------------------------------------------------
insert into eshop.images(product_id, primary_flag, image_path)
values (1, 1, 'mobile-iphone-13-mini-128gb-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (1, 0, 'mobile-iphone-13-mini-128gb-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (1, 0, 'mobile-iphone-13-mini-128gb-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (1, 0, 'mobile-iphone-13-mini-128gb-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (1, 0, 'mobile-iphone-13-mini-128gb-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (2, 1, 'mobile-nokia-g21-128gb-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (2, 0, 'mobile-nokia-g21-128gb-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (2, 0, 'mobile-nokia-g21-128gb-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (2, 0, 'mobile-nokia-g21-128gb-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (2, 0, 'mobile-nokia-g21-128gb-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (3, 1, 'mobile-xiaomi-12-lite-8gb-256gb-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (3, 0, 'mobile-xiaomi-12-lite-8gb-256gb-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (3, 0, 'mobile-xiaomi-12-lite-8gb-256gb-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (3, 0, 'mobile-xiaomi-12-lite-8gb-256gb-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (3, 0, 'mobile-xiaomi-12-lite-8gb-256gb-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (4, 1, 'mobile-samsung-a32-128gb-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (4, 0, 'mobile-samsung-a32-128gb-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (4, 0, 'mobile-samsung-a32-128gb-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (4, 0, 'mobile-samsung-a32-128gb-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (4, 0, 'mobile-samsung-a32-128gb-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (5, 1, 'mobile-xiaomi-redmi-note-11-pro-8gb-128gb-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (5, 0, 'mobile-xiaomi-redmi-note-11-pro-8gb-128gb-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (5, 0, 'mobile-xiaomi-redmi-note-11-pro-8gb-128gb-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (5, 0, 'mobile-xiaomi-redmi-note-11-pro-8gb-128gb-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (5, 0, 'mobile-xiaomi-redmi-note-11-pro-8gb-128gb-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (6, 1, 'mobile-huawei-p50-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (6, 0, 'mobile-huawei-p50-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (6, 0, 'mobile-huawei-p50-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (6, 0, 'mobile-huawei-p50-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (6, 0, 'mobile-huawei-p50-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (7, 1, 'mobile-poco-f3-8gb-256gb-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (7, 0, 'mobile-poco-f3-8gb-256gb-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (7, 0, 'mobile-poco-f3-8gb-256gb-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (7, 0, 'mobile-poco-f3-8gb-256gb-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (7, 0, 'mobile-poco-f3-8gb-256gb-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (8, 1, 'mobile-huawei-p50-pocket-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (8, 0, 'mobile-huawei-p50-pocket-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (8, 0, 'mobile-huawei-p50-pocket-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (8, 0, 'mobile-huawei-p50-pocket-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (8, 0, 'mobile-huawei-p50-pocket-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (9, 1, 'mobile-vivo-y21-4gb-64gb-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (9, 0, 'mobile-vivo-y21-4gb-64gb-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (9, 0, 'mobile-vivo-y21-4gb-64gb-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (9, 0, 'mobile-vivo-y21-4gb-64gb-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (9, 0, 'mobile-vivo-y21-4gb-64gb-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (10, 1, 'mobile-samsung-galaxy-s22-ultra-256gb-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (10, 0, 'mobile-samsung-galaxy-s22-ultra-256gb-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (10, 0, 'mobile-samsung-galaxy-s22-ultra-256gb-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (10, 0, 'mobile-samsung-galaxy-s22-ultra-256gb-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (10, 0, 'mobile-samsung-galaxy-s22-ultra-256gb-5.jpg');

insert into eshop.images(product_id, primary_flag, image_path)
values (11, 1, 'laptop-acer-nitro-5-an517-54-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (11, 0, 'laptop-acer-nitro-5-an517-54-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (11, 0, 'laptop-acer-nitro-5-an517-54-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (11, 0, 'laptop-acer-nitro-5-an517-54-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (11, 0, 'laptop-acer-nitro-5-an517-54-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (12, 1, 'laptop-asus-gaming-tuf-fx506hcb-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (12, 0, 'laptop-asus-gaming-tuf-fx506hcb-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (12, 0, 'laptop-asus-gaming-tuf-fx506hcb-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (12, 0, 'laptop-asus-gaming-tuf-fx506hcb-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (12, 0, 'laptop-asus-gaming-tuf-fx506hcb-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (13, 1, 'laptop-hp-victus-e0504nw-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (13, 0, 'laptop-hp-victus-e0504nw-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (13, 0, 'laptop-hp-victus-e0504nw-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (13, 0, 'laptop-hp-victus-e0504nw-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (13, 0, 'laptop-hp-victus-e0504nw-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (14, 1, 'laptop-lenovo-ideapad-5-82ln00t5re-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (14, 0, 'laptop-lenovo-ideapad-5-82ln00t5re-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (14, 0, 'laptop-lenovo-ideapad-5-82ln00t5re-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (14, 0, 'laptop-lenovo-ideapad-5-82ln00t5re-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (14, 0, 'laptop-lenovo-ideapad-5-82ln00t5re-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (15, 1, 'laptop-asus-rog-g15-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (15, 0, 'laptop-asus-rog-g15-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (15, 0, 'laptop-asus-rog-g15-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (15, 0, 'laptop-asus-rog-g15-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (15, 0, 'laptop-asus-rog-g15-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (16, 1, 'laptop-msi-katana-gf76-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (16, 0, 'laptop-msi-katana-gf76-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (16, 0, 'laptop-msi-katana-gf76-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (16, 0, 'laptop-msi-katana-gf76-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (16, 0, 'laptop-msi-katana-gf76-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (17, 1, 'laptop-lenovo-legion-5-pro-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (17, 0, 'laptop-lenovo-legion-5-pro-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (17, 0, 'laptop-lenovo-legion-5-pro-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (17, 0, 'laptop-lenovo-legion-5-pro-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (17, 0, 'laptop-lenovo-legion-5-pro-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (18, 1, 'laptop-dell-g15-5515-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (18, 0, 'laptop-dell-g15-5515-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (18, 0, 'laptop-dell-g15-5515-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (18, 0, 'laptop-dell-g15-5515-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (18, 0, 'laptop-dell-g15-5515-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (19, 1, 'laptop-dell-alienware-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (19, 0, 'laptop-dell-alienware-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (19, 0, 'laptop-dell-alienware-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (19, 0, 'laptop-dell-alienware-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (19, 0, 'laptop-dell-alienware-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (20, 1, 'laptop-apple-macbook-pro-14-m1-pro-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (20, 0, 'laptop-apple-macbook-pro-14-m1-pro-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (20, 0, 'laptop-apple-macbook-pro-14-m1-pro-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (20, 0, 'laptop-apple-macbook-pro-14-m1-pro-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (20, 0, 'laptop-apple-macbook-pro-14-m1-pro-5.jpg');

insert into eshop.images(product_id, primary_flag, image_path)
values (21, 1, 'gps-navitel-n500-magnetic-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (21, 0, 'gps-navitel-n500-magnetic-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (21, 0, 'gps-navitel-n500-magnetic-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (21, 0, 'gps-navitel-n500-magnetic-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (21, 0, 'gps-navitel-n500-magnetic-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (22, 1, 'gps-navitel-t737-pro-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (22, 0, 'gps-navitel-t737-pro-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (22, 0, 'gps-navitel-t737-pro-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (23, 1, 'gps-prestigio-5068-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (23, 0, 'gps-prestigio-5068-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (23, 0, 'gps-prestigio-5068-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (23, 0, 'gps-prestigio-5068-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (24, 1, 'gps-prestigio-5850-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (24, 0, 'gps-prestigio-5850-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (24, 0, 'gps-prestigio-5850-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (24, 0, 'gps-prestigio-5850-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (24, 0, 'gps-prestigio-5850-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (25, 1, 'gps-prestigio-7777-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (25, 0, 'gps-prestigio-7777-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (25, 0, 'gps-prestigio-7777-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (25, 0, 'gps-prestigio-7777-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (25, 0, 'gps-prestigio-7777-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (26, 1, 'gps-navitel-g550-moto-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (26, 0, 'gps-navitel-g550-moto-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (26, 0, 'gps-navitel-g550-moto-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (26, 0, 'gps-navitel-g550-moto-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (26, 0, 'gps-navitel-g550-moto-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (27, 1, 'gps-navitel-f150-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (27, 0, 'gps-navitel-f150-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (27, 0, 'gps-navitel-f150-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (27, 0, 'gps-navitel-f150-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (27, 0, 'gps-navitel-f150-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (28, 1, 'gps-garmin-drive-51-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (28, 0, 'gps-garmin-drive-51-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (28, 0, 'gps-garmin-drive-51-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (28, 0, 'gps-garmin-drive-51-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (28, 0, 'gps-garmin-drive-51-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (29, 1, 'gps-navitel-e500-magnetic-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (29, 0, 'gps-navitel-e500-magnetic-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (29, 0, 'gps-navitel-e500-magnetic-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (29, 0, 'gps-navitel-e500-magnetic-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (29, 0, 'gps-navitel-e500-magnetic-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (30, 1, 'gps-prestigio-geovisiontour-4-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (30, 0, 'gps-prestigio-geovisiontour-4-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (30, 0, 'gps-prestigio-geovisiontour-4-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (30, 0, 'gps-prestigio-geovisiontour-4-4.jpg');

insert into eshop.images(product_id, primary_flag, image_path)
values (31, 1, 'fridge-indesit-5200-w-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (31, 0, 'fridge-indesit-5200-w-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (31, 0, 'fridge-indesit-5200-w-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (31, 0, 'fridge-indesit-5200-w-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (31, 0, 'fridge-indesit-5200-w-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (32, 1, 'fridge-bosch-serie-4-vitafresh-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (32, 0, 'fridge-bosch-serie-4-vitafresh-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (32, 0, 'fridge-bosch-serie-4-vitafresh-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (32, 0, 'fridge-bosch-serie-4-vitafresh-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (32, 0, 'fridge-bosch-serie-4-vitafresh-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (33, 1, 'fridge-lg-doorcooling-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (33, 0, 'fridge-lg-doorcooling-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (33, 0, 'fridge-lg-doorcooling-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (33, 0, 'fridge-lg-doorcooling-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (33, 0, 'fridge-lg-doorcooling-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (34, 1, 'fridge-atlant-xm-4425-000-n-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (34, 0, 'fridge-atlant-xm-4425-000-n-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (34, 0, 'fridge-atlant-xm-4425-000-n-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (34, 0, 'fridge-atlant-xm-4425-000-n-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (34, 0, 'fridge-atlant-xm-4425-000-n-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (35, 1, 'fridge-samsung-rb33a32n0sa-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (35, 0, 'fridge-samsung-rb33a32n0sa-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (35, 0, 'fridge-samsung-rb33a32n0sa-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (35, 0, 'fridge-samsung-rb33a32n0sa-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (35, 0, 'fridge-samsung-rb33a32n0sa-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (36, 1, 'fridge-atlant-hm-6025-582-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (36, 0, 'fridge-atlant-hm-6025-582-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (36, 0, 'fridge-atlant-hm-6025-582-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (36, 0, 'fridge-atlant-hm-6025-582-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (36, 0, 'fridge-atlant-hm-6025-582-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (37, 1, 'fridge-haier-hrf-541dm7ru-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (37, 0, 'fridge-haier-hrf-541dm7ru-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (37, 0, 'fridge-haier-hrf-541dm7ru-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (37, 0, 'fridge-haier-hrf-541dm7ru-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (37, 0, 'fridge-haier-hrf-541dm7ru-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (38, 1, 'fridge-atlant-xm-4307-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (38, 0, 'fridge-atlant-xm-4307-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (38, 0, 'fridge-atlant-xm-4307-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (38, 0, 'fridge-atlant-xm-4307-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (38, 0, 'fridge-atlant-xm-4307-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (39, 1, 'fridge-maunfeld-mff177nfsb-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (39, 0, 'fridge-maunfeld-mff177nfsb-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (39, 0, 'fridge-maunfeld-mff177nfsb-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (39, 0, 'fridge-maunfeld-mff177nfsb-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (39, 0, 'fridge-maunfeld-mff177nfsb-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (40, 1, 'fridge-lg-b257jlyv-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (40, 0, 'fridge-lg-b257jlyv-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (40, 0, 'fridge-lg-b257jlyv-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (40, 0, 'fridge-lg-b257jlyv-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (40, 0, 'fridge-lg-b257jlyv-5.jpg');

insert into eshop.images(product_id, primary_flag, image_path)
values (41, 1, 'tv-lg-50nano766qa-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (41, 0, 'tv-lg-50nano766qa-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (41, 0, 'tv-lg-50nano766qa-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (41, 0, 'tv-lg-50nano766qa-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (41, 0, 'tv-lg-50nano766qa-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (42, 1, 'tv-samsung-ue55au8000uxru-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (42, 0, 'tv-samsung-ue55au8000uxru-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (42, 0, 'tv-samsung-ue55au8000uxru-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (42, 0, 'tv-samsung-ue55au8000uxru-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (42, 0, 'tv-samsung-ue55au8000uxru-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (43, 1, 'tv-samsung-ue50au7170uxru-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (43, 0, 'tv-samsung-ue50au7170uxru-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (43, 0, 'tv-samsung-ue50au7170uxru-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (43, 0, 'tv-samsung-ue50au7170uxru-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (43, 0, 'tv-samsung-ue50au7170uxru-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (44, 1, 'tv-lg-43uq75006lf-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (44, 0, 'tv-lg-43uq75006lf-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (44, 0, 'tv-lg-43uq75006lf-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (44, 0, 'tv-lg-43uq75006lf-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (44, 0, 'tv-lg-43uq75006lf-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (45, 1, 'tv-tlc-50p615-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (45, 0, 'tv-tlc-50p615-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (45, 0, 'tv-tlc-50p615-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (45, 0, 'tv-tlc-50p615-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (45, 0, 'tv-tlc-50p615-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (46, 1, 'tv-tlc-65p725-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (46, 0, 'tv-tlc-65p725-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (46, 0, 'tv-tlc-65p725-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (46, 0, 'tv-tlc-65p725-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (46, 0, 'tv-tlc-65p725-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (47, 1, 'tv-sony-kd-65x85tj-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (47, 0, 'tv-sony-kd-65x85tj-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (47, 0, 'tv-sony-kd-65x85tj-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (47, 0, 'tv-sony-kd-65x85tj-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (47, 0, 'tv-sony-kd-65x85tj-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (48, 1, 'tv-kivi-40f740lb-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (48, 0, 'tv-kivi-40f740lb-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (48, 0, 'tv-kivi-40f740lb-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (48, 0, 'tv-kivi-40f740lb-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (48, 0, 'tv-kivi-40f740lb-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (49, 1, 'tv-kivi-32f790lw-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (49, 0, 'tv-kivi-32f790lw-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (49, 0, 'tv-kivi-32f790lw-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (49, 0, 'tv-kivi-32f790lw-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (49, 0, 'tv-kivi-32f790lw-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (50, 1, 'tv-philips-50pus7956-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (50, 0, 'tv-philips-50pus7956-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (50, 0, 'tv-philips-50pus7956-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (50, 0, 'tv-philips-50pus7956-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (50, 0, 'tv-philips-50pus7956-5.jpg');

insert into eshop.images(product_id, primary_flag, image_path)
values (51, 1, 'camera-canon-eos-850d-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (51, 0, 'camera-canon-eos-850d-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (51, 0, 'camera-canon-eos-850d-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (51, 0, 'camera-canon-eos-850d-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (51, 0, 'camera-canon-eos-850d-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (52, 1, 'camera-sony-zv-1-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (52, 0, 'camera-sony-zv-1-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (52, 0, 'camera-sony-zv-1-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (52, 0, 'camera-sony-zv-1-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (52, 0, 'camera-sony-zv-1-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (53, 1, 'camera-canon-eos-rp-rf-24-105-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (53, 0, 'camera-canon-eos-rp-rf-24-105-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (53, 0, 'camera-canon-eos-rp-rf-24-105-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (53, 0, 'camera-canon-eos-rp-rf-24-105-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (54, 1, 'camera-sony-zv-1-pro-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (54, 0, 'camera-sony-zv-1-pro-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (54, 0, 'camera-sony-zv-1-pro-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (54, 0, 'camera-sony-zv-1-pro-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (54, 0, 'camera-sony-zv-1-pro-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (55, 1, 'camera-nikon-d3300-18-55-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (55, 0, 'camera-nikon-d3300-18-55-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (55, 0, 'camera-nikon-d3300-18-55-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (55, 0, 'camera-nikon-d3300-18-55-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (55, 0, 'camera-nikon-d3300-18-55-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (56, 1, 'camera-nikon-b700-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (56, 0, 'camera-nikon-b700-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (56, 0, 'camera-nikon-b700-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (56, 0, 'camera-nikon-b700-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (56, 0, 'camera-nikon-b700-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (57, 1, 'camera-canon-eos-r-rf-24-105-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (57, 0, 'camera-canon-eos-r-rf-24-105-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (57, 0, 'camera-canon-eos-r-rf-24-105-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (57, 0, 'camera-canon-eos-r-rf-24-105-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (57, 0, 'camera-canon-eos-r-rf-24-105-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (58, 1, 'camera-r6-rf24-105-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (58, 0, 'camera-r6-rf24-105-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (58, 0, 'camera-r6-rf24-105-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (58, 0, 'camera-r6-rf24-105-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (58, 0, 'camera-r6-rf24-105-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (59, 1, 'camera-canon-eos-m6-mark-ii-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (59, 0, 'camera-canon-eos-m6-mark-ii-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (59, 0, 'camera-canon-eos-m6-mark-ii-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (59, 0, 'camera-canon-eos-m6-mark-ii-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (59, 0, 'camera-canon-eos-m6-mark-ii-5.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (60, 1, 'camera-sony-alpha-a5000-1.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (60, 0, 'camera-sony-alpha-a5000-2.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (60, 0, 'camera-sony-alpha-a5000-3.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (60, 0, 'camera-sony-alpha-a5000-4.jpg');
insert into eshop.images(product_id, primary_flag, image_path)
values (60, 0, 'camera-sony-alpha-a5000-5.jpg');

#--------------------------------------------------------
--  DML for Table ESHOP.USERS
#--------------------------------------------------------
insert into eshop.users (login, name, surname, password, date_of_birth, email, balance)
values ('max', 'Maxim', 'Maximov', '$2a$10$y8clbYmew8wmGPIebWW2OOavse0v1AOMb39L9n/t0SJ.avbvmtBtq', '1990-08-23',
        'max@mail.by', 0);
insert into eshop.users (login, name, surname, password, date_of_birth, email, balance)
values ('ivan', 'Ivan', 'Ivanov', '$2a$10$y8clbYmew8wmGPIebWW2OOavse0v1AOMb39L9n/t0SJ.avbvmtBtq', '1983-04-02',
        'ivan@mail.by', 0);
#--------------------------------------------------------
--  DML for Table ESHOP.ROLES
#--------------------------------------------------------
insert into eshop.roles (id, name)
values (1, 'ROLE_ADMIN');
insert into eshop.roles (id, name)
values (2, 'ROLE_USER');
#--------------------------------------------------------
--  DML for Table ESHOP.USER_ROLES
#--------------------------------------------------------
insert into eshop.user_roles (user_id, role_id)
values (1, 1);
insert into eshop.user_roles (user_id, role_id)
values (1, 2);
insert into eshop.user_roles (user_id, role_id)
values (2, 2);
#--------------------------------------------------------
--  DML for Table ESHOP.ORDERS
#--------------------------------------------------------
insert into eshop.orders (`price`, `date`, `user_id`)
values ('2000', NOW(), '1');
insert into eshop.orders (`price`, `date`, `user_id`)
values ('2000', NOW(), '2');
insert into eshop.orders (`price`, `date`, `user_id`)
values ('2000', NOW(), '1');
insert into eshop.orders (`price`, `date`, `user_id`)
values ('2000', NOW(), '2');
#--------------------------------------------------------
--  DML for Table ESHOP.ORDER_PRODUCTS
#--------------------------------------------------------
insert into eshop.order_products (order_id, product_id, quantity)
values ('1', '1', '1');
insert into eshop.order_products (order_id, product_id, quantity)
values ('1', '3', '2');
insert into eshop.order_products (order_id, product_id, quantity)
values ('1', '4', '1');
insert into eshop.order_products (order_id, product_id, quantity)
values ('1', '5', '5');
insert into eshop.order_products (order_id, product_id, quantity)
values ('2', '3', '1');
insert into eshop.order_products (order_id, product_id, quantity)
values ('2', '7', '2');
insert into eshop.order_products (order_id, product_id, quantity)
values ('3', '1', '2');
insert into eshop.order_products (order_id, product_id, quantity)
values ('3', '2', '2');
insert into eshop.order_products (order_id, product_id, quantity)
values ('4', '7', '1');
insert into eshop.order_products (order_id, product_id, quantity)
values ('4', '8', '3');
