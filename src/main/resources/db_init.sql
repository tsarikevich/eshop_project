#--------------------------------------------------------
--  DDL for schema ESHOP
#--------------------------------------------------------
DROP SCHEMA IF EXISTS eshop;
CREATE SCHEMA IF NOT EXISTS eshop;

#--------------------------------------------------------
--  DDL for Table CATEGORY
#--------------------------------------------------------
DROP TABLE IF EXISTS eshop.categories;
CREATE TABLE IF NOT EXISTS eshop.categories
(
    ID     INT         NOT NULL AUTO_INCREMENT,
    NAME   VARCHAR(45) NOT NULL,
    RATING DOUBLE      NOT NULL,
    PRIMARY KEY (ID),
    UNIQUE INDEX IDX_CATEGORIES_CATEGORY_ID_UNIQUE (ID ASC),
    UNIQUE INDEX IDX_CATEGORIES_NAME_UNIQUE (NAME ASC)
);
#--------------------------------------------------------
--  DDL for Table PRODUCTS
#--------------------------------------------------------
DROP TABLE IF EXISTS eshop.products;
CREATE TABLE IF NOT EXISTS eshop.products
(
    ID          INT          NOT NULL AUTO_INCREMENT,
    NAME        VARCHAR(200) NOT NULL,
    DESCRIPTION VARCHAR(400) NOT NULL,
    PRICE       DECIMAL      NOT NULL,
    CATEGORY_ID INT          NOT NULL,
    PRIMARY KEY (ID),
    UNIQUE INDEX IDX_PRODUCTS_ID_UNIQUE (ID ASC),
    UNIQUE INDEX IDX_NAME_UNIQUE (NAME ASC),
    CONSTRAINT FK_PRODUCTS_CATEGORY_ID_CATEGORIES_ID
        FOREIGN KEY (CATEGORY_ID) references eshop.categories (ID)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);
#--------------------------------------------------------
--  DDL for Table USERS
#--------------------------------------------------------
DROP TABLE IF EXISTS eshop.users;
CREATE TABLE IF NOT EXISTS eshop.users
(
    ID            INT          NOT NULL AUTO_INCREMENT,
    LOGIN         VARCHAR(50)  NOT NULL,
    NAME          VARCHAR(100) NOT NULL,
    SURNAME       VARCHAR(200) NOT NULL,
    PASSWORD      VARCHAR(100) NOT NULL,
    DATE_OF_BIRTH DATE         NOT NULL,
    EMAIL         VARCHAR(100) NOT NULL,
    BALANCE       DECIMAL,
    PRIMARY KEY (ID),
    UNIQUE INDEX IDX_USERS_USER_ID_UNIQUE (ID ASC),
    UNIQUE INDEX IDX_USERS_LOGIN_UNIQUE (LOGIN ASC),
    UNIQUE INDEX IDX_USERS_EMAIL_UNIQUE (EMAIL ASC)
);
#--------------------------------------------------------
--  DDL for Table ORDERS
#--------------------------------------------------------
DROP TABLE IF EXISTS eshop.orders;
CREATE TABLE IF NOT EXISTS eshop.orders
(
    ID      INT      NOT NULL AUTO_INCREMENT,
    PRICE   DECIMAL  NOT NULL,
    DATE    DATETIME NOT NULL,
    USER_ID INT      NOT NULL,
    PRIMARY KEY (ID),
    UNIQUE INDEX IDX_ORDERS_ID_UNIQUE (ID ASC),
    CONSTRAINT FK_ORDERS_USER_ID_USERS_ID
        FOREIGN KEY (USER_ID) references eshop.users (ID)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);
#--------------------------------------------------------
--  DDL for Table PRODUCT_IMAGES
#--------------------------------------------------------
DROP TABLE IF EXISTS eshop.images;
CREATE TABLE IF NOT EXISTS eshop.images
(
    ID           INT          NOT NULL AUTO_INCREMENT,
    CATEGORY_ID  INT,
    PRODUCT_ID   INT,
    PRIMARY_FLAG BOOLEAN      NOT NULL,
    IMAGE_PATH   VARCHAR(200) NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT FK_IMAGES_CATEGORY_ID_CATEGORIES_ID
        FOREIGN KEY (CATEGORY_ID) references eshop.categories (ID)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    CONSTRAINT FK_IMAGES_PRODUCT_ID_PRODUCTS_ID
        FOREIGN KEY (PRODUCT_ID) REFERENCES eshop.products (ID)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);
#--------------------------------------------------------
--  DDL for Table ORDER_PRODUCTS
#--------------------------------------------------------
DROP TABLE IF EXISTS eshop.order_products;
CREATE TABLE IF NOT EXISTS eshop.order_products
(
    ORDER_ID   INT NOT NULL,
    PRODUCT_ID INT NOT NULL,
    QUANTITY   INT NOT NULL,
    PRIMARY KEY (ORDER_ID, PRODUCT_ID),
    CONSTRAINT FK_ORDER_PRODUCTS_ORDER_ID_ORDERS_ID
        FOREIGN KEY (ORDER_ID)
            REFERENCES orders (ID)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    CONSTRAINT FK_ORDER_PRODUCTS_PRODUCT_ID_PRODUCTS_ID
        FOREIGN KEY (PRODUCT_ID)
            REFERENCES products (ID)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);
#--------------------------------------------------------
--  DDL for Table ROLES
#--------------------------------------------------------
DROP TABLE IF EXISTS eshop.roles;
CREATE TABLE IF NOT EXISTS eshop.roles
(
    ID   INT         NOT NULL AUTO_INCREMENT,
    NAME VARCHAR(45) NOT NULL,
    PRIMARY KEY (ID),
    UNIQUE INDEX IDX_ROLES_ROLE_ID_UNIQUE (ID ASC),
    UNIQUE INDEX IDX_ROLES_NAME_UNIQUE (NAME ASC)
);
#--------------------------------------------------------
--  DDL for Table USERS_ROLES
#--------------------------------------------------------
DROP TABLE IF EXISTS eshop.user_roles;
CREATE TABLE IF NOT EXISTS eshop.user_roles
(
    USER_ID INT NOT NULL,
    ROLE_ID INT NOT NULL,
    PRIMARY KEY (USER_ID, ROLE_ID),
    CONSTRAINT FK_USER_PRODUCTS_USER_ID_USERS_ID
        FOREIGN KEY (USER_ID)
            REFERENCES users (ID)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    CONSTRAINT FK_USER_ROLES_ROLE_ID_ROLES_ID
        FOREIGN KEY (ROLE_ID)
            REFERENCES roles (ID)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);
#--------------------------------------------------------
--  DML for Table ESHOP.CATEGORIES
#--------------------------------------------------------

INSERT INTO eshop.categories (ID, NAME, RATING)
VALUES (1, 'Mobile phones', 5);
INSERT INTO eshop.categories (ID, NAME, RATING)
VALUES (2, 'Laptops', 5);
INSERT INTO eshop.categories (ID, NAME, RATING)
VALUES (3, 'GPS Navigators', 5);
INSERT INTO eshop.categories (ID, NAME, RATING)
VALUES (4, 'Fridges', 5);
INSERT INTO eshop.categories (ID, NAME, RATING)
VALUES (5, 'Cars', 5);
INSERT INTO eshop.categories (ID, NAME, RATING)
VALUES (6, 'Cameras', 5);
#--------------------------------------------------------
--  DML for Table ESHOP.PRODUCTS
#--------------------------------------------------------
INSERT INTO eshop.products (ID, NAME, DESCRIPTION, PRICE, CATEGORY_ID)
VALUES (1, 'Смартфон Apple iPhone 13 128GB (темная ночь)',
        'Apple iOS, экран 6.1'''' OLED (1170x2532), Apple A15 Bionic, ОЗУ 4 ГБ, флэш-память 128 ГБ, камера 12 Мп, аккумулятор 3227 мАч, 1 SIM',
        2600, 1);
INSERT INTO eshop.products (ID, NAME, DESCRIPTION, PRICE, CATEGORY_ID)
VALUES (2, 'Смартфон Samsung Galaxy A52 SM-A525F/DS 8GB/256GB (синий)',
        'Android, экран 6.5'''' AMOLED (1080x2400), Qualcomm Snapdragon 720G, ОЗУ 8 ГБ, флэш-память 256 ГБ, карты памяти, камера 64 Мп, аккумулятор 4500 мАч, 2 SIM',
        1200, 1);
INSERT INTO eshop.products (ID, NAME, DESCRIPTION, PRICE, CATEGORY_ID)
VALUES (3, 'Игровой ноутбук Lenovo Legion 5 15ACH6H 82JU00A1PB',
        '15.6'''' 1920 x 1080 IPS, 120 Гц, несенсорный, AMD Ryzen 7 5800H 3200 МГц, 16 ГБ DDR4, SSD 512 ГБ, видеокарта NVIDIA GeForce RTX 3060 6 ГБ, Windows 10, цвет крышки темно-синий',
        5500, 2);
INSERT INTO eshop.products (ID, NAME, DESCRIPTION, PRICE, CATEGORY_ID)
VALUES (4, 'Игровой ноутбук Acer Nitro 5 AN515-45-R1A6 NH.QBREP.00B',
        '15.6'''' 1920 x 1080 IPS, 144 Гц, несенсорный, AMD Ryzen 5 5600H 3300 МГц, 16 ГБ DDR4, SSD 1024 ГБ, видеокарта NVIDIA GeForce RTX 3070 8 ГБ, Linux, цвет крышки черный',
        5000, 2);
INSERT INTO eshop.products (ID, NAME, DESCRIPTION, PRICE, CATEGORY_ID)
VALUES (5, 'GPS навигатор GEOFOX MID502GPS',
        'экран 5'''' TFT (800 x 480), ОЗУ 128 Мб, флэш-память 8 Гб, Windows CE 6.0',
        222, 3);
INSERT INTO eshop.products (ID, NAME, DESCRIPTION, PRICE, CATEGORY_ID)
VALUES (6, 'GPS навигатор NAVITEL E707 Magnetic',
        'экран 7'''' TFT (800 x 480), процессор MStar MSB2531 800 МГц, флэш-память 8 Гб, Linux',
        342, 3);
INSERT INTO eshop.products (ID, NAME, DESCRIPTION, PRICE, CATEGORY_ID)
VALUES (7, 'Холодильник Bosch Serie 6 VitaFresh Plus KGN39AI32R',
        'отдельностоящий, полный No Frost, электронное управление, класс A++, полезный объём: 388 л (280 + 108 л), инверторный компрессор, зона свежести, перенавешиваемые двери, складная полка, полка для вина, лоток для яиц, отделка: защита от отпечатков, 60x66x203 см, нержавеющая сталь',
        2950, 4);
INSERT INTO eshop.products (ID, NAME, DESCRIPTION, PRICE, CATEGORY_ID)
VALUES (8, 'Холодильник Samsung RB37A52N0B1/WT',
        'отдельностоящий, полный No Frost, электронное управление, класс A+, полезный объём: 367 л (269 + 98 л), инверторный компрессор, перенавешиваемые двери, лоток для яиц, 59.5x64.7x201 см, черный',
        2248, 4);
INSERT INTO eshop.products (ID, NAME, DESCRIPTION, PRICE, CATEGORY_ID)
VALUES (9, 'Volvo XC40', '1.6 T3 MT Turbo Momentum', 87832, 5);
INSERT INTO eshop.products (ID, NAME, DESCRIPTION, PRICE, CATEGORY_ID)
VALUES (10, 'Tesla Model X', 'электрический двигатель, P100D Long Range', 272107, 5);
INSERT INTO eshop.products (ID, NAME, DESCRIPTION, PRICE, CATEGORY_ID)
VALUES (11, 'Зеркальный фотоаппарат Canon EOS 4000D Kit 18-55mm III',
        'зеркальная камера, байонет Canon EF-S, матрица APS-C (1.6 crop) 18 Мп, с объективом F3.5-5.6 18-55 мм, Wi-Fi',
        1449, 6);
INSERT INTO eshop.products (ID, NAME, DESCRIPTION, PRICE, CATEGORY_ID)
VALUES (12, 'Зеркальный фотоаппарат Nikon D5600 Kit 18-55mm AF-P DX VR',
        'Зеркальный фотоаппарат Nikon D5600 Kit 18-55mm AF-P DX VR', 2550, 6);
#--------------------------------------------------------
--  DML for Table ESHOP.IMAGES
# --------------------------------------------------------
INSERT INTO eshop.images(CATEGORY_ID, PRIMARY_FLAG, IMAGE_PATH)
values (1, 1, 'mobile.jpg');
INSERT INTO eshop.images(CATEGORY_ID, PRIMARY_FLAG, IMAGE_PATH)
values (2, 1, 'laptop.jpg');
INSERT INTO eshop.images(CATEGORY_ID, PRIMARY_FLAG, IMAGE_PATH)
values (3, 1, 'jps_nav.jpg');
INSERT INTO eshop.images(CATEGORY_ID, PRIMARY_FLAG, IMAGE_PATH)
values (4, 1, 'fridge.jpg');
INSERT INTO eshop.images(CATEGORY_ID, PRIMARY_FLAG, IMAGE_PATH)
values (5, 1, 'car.jpg');
INSERT INTO eshop.images(CATEGORY_ID, PRIMARY_FLAG, IMAGE_PATH)
values (6, 1, 'camera.jpg');
INSERT INTO eshop.images(CATEGORY_ID, PRODUCT_ID, PRIMARY_FLAG, IMAGE_PATH)
values (1, 1, 1, 'mobileApple.jpg');
INSERT INTO eshop.images(CATEGORY_ID, PRODUCT_ID, PRIMARY_FLAG, IMAGE_PATH)
values (1, 2, 1, 'mobileSamsung.jpg');
INSERT INTO eshop.images(CATEGORY_ID, PRODUCT_ID, PRIMARY_FLAG, IMAGE_PATH)
values (2, 3, 1, 'laptopLenovo.jpg');
INSERT INTO eshop.images(CATEGORY_ID, PRODUCT_ID, PRIMARY_FLAG, IMAGE_PATH)
values (2, 4, 1, 'laptopAcer.jpg');
INSERT INTO eshop.images(CATEGORY_ID, PRODUCT_ID, PRIMARY_FLAG, IMAGE_PATH)
values (3, 5, 1, 'navigatorGeofox.jpg');
INSERT INTO eshop.images(CATEGORY_ID, PRODUCT_ID, PRIMARY_FLAG, IMAGE_PATH)
values (3, 6, 1, 'navigatorNavitel.jpg');
INSERT INTO eshop.images(CATEGORY_ID, PRODUCT_ID, PRIMARY_FLAG, IMAGE_PATH)
values (4, 7, 1, 'fridgeBosch.jpg');
INSERT INTO eshop.images(CATEGORY_ID, PRODUCT_ID, PRIMARY_FLAG, IMAGE_PATH)
values (4, 8, 1, 'fridgeSamsung.jpg');
INSERT INTO eshop.images(CATEGORY_ID, PRODUCT_ID, PRIMARY_FLAG, IMAGE_PATH)
values (5, 9, 1, 'carVolvo.jpg');
INSERT INTO eshop.images(CATEGORY_ID, PRODUCT_ID, PRIMARY_FLAG, IMAGE_PATH)
values (5, 10, 1, 'carTesla.jpg');
INSERT INTO eshop.images(CATEGORY_ID, PRODUCT_ID, PRIMARY_FLAG, IMAGE_PATH)
values (6, 11, 1, 'cameraCanon.jpg');
INSERT INTO eshop.images(CATEGORY_ID, PRODUCT_ID, PRIMARY_FLAG, IMAGE_PATH)
values (6, 12, 1, 'cameraNikon.jpg');
#--------------------------------------------------------
--  DML for Table ESHOP.USERS
#--------------------------------------------------------
INSERT INTO eshop.users (LOGIN, NAME, SURNAME, PASSWORD, DATE_OF_BIRTH, EMAIL)
VALUES ('max', 'max', 'max', '$2a$10$y8clbYmew8wmGPIebWW2OOavse0v1AOMb39L9n/t0SJ.avbvmtBtq', NOW(), 'max@mail.by');
INSERT INTO eshop.users (LOGIN, NAME, SURNAME, PASSWORD, DATE_OF_BIRTH, EMAIL)
VALUES ('max1', 'max1', 'max1', '$2a$10$y8clbYmew8wmGPIebWW2OOavse0v1AOMb39L9n/t0SJ.avbvmtBtq', NOW(), 'max1@mail.by');
#--------------------------------------------------------
--  DML for Table ESHOP.ROLES
#--------------------------------------------------------
INSERT INTO eshop.roles (ID, NAME)
VALUES (1, 'ROLE_ADMIN');
INSERT INTO eshop.roles (ID, NAME)
VALUES (2, 'ROLE_USER');
#--------------------------------------------------------
--  DML for Table ESHOP.USER_ROLES
#--------------------------------------------------------
INSERT INTO eshop.user_roles (USER_ID, ROLE_ID)
VALUES (1, 1);
INSERT INTO eshop.user_roles (USER_ID, ROLE_ID)
VALUES (2, 2);
#--------------------------------------------------------
--  DML for Table ESHOP.ORDERS
#--------------------------------------------------------
INSERT INTO eshop.orders (`PRICE`, `DATE`, `USER_ID`)
VALUES ('2000', NOW(), '1');
INSERT INTO eshop.orders (`PRICE`, `DATE`, `USER_ID`)
VALUES ('2000', NOW(), '2');
INSERT INTO eshop.orders (`PRICE`, `DATE`, `USER_ID`)
VALUES ('2000', NOW(), '1');
INSERT INTO eshop.orders (`PRICE`, `DATE`, `USER_ID`)
VALUES ('2000', NOW(), '2');
#--------------------------------------------------------
--  DML for Table ESHOP.ORDER_PRODUCTS
#--------------------------------------------------------
INSERT INTO eshop.order_products (ORDER_ID, PRODUCT_ID, QUANTITY)
VALUES ('1', '1', '1');
INSERT INTO eshop.order_products (ORDER_ID, PRODUCT_ID, QUANTITY)
VALUES ('1', '3', '2');
INSERT INTO eshop.order_products (ORDER_ID, PRODUCT_ID, QUANTITY)
VALUES ('1', '4', '1');
INSERT INTO eshop.order_products (ORDER_ID, PRODUCT_ID, QUANTITY)
VALUES ('1', '5', '5');
INSERT INTO eshop.order_products (ORDER_ID, PRODUCT_ID, QUANTITY)
VALUES ('2', '3', '1');
INSERT INTO eshop.order_products (ORDER_ID, PRODUCT_ID, QUANTITY)
VALUES ('2', '7', '2');
INSERT INTO eshop.order_products (ORDER_ID, PRODUCT_ID, QUANTITY)
VALUES ('3', '1', '2');
INSERT INTO eshop.order_products (ORDER_ID, PRODUCT_ID, QUANTITY)
VALUES ('3', '2', '2');
INSERT INTO eshop.order_products (ORDER_ID, PRODUCT_ID, QUANTITY)
VALUES ('4', '7', '1');
INSERT INTO eshop.order_products (ORDER_ID, PRODUCT_ID, QUANTITY)
VALUES ('4', '8', '3');
