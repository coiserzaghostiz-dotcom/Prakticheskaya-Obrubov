PRAGMA foreign_keys=ON;

CREATE TABLE customers(customer_id INTEGER PRIMARY KEY, full_name TEXT NOT NULL, phone TEXT NOT NULL UNIQUE);
CREATE TABLE vehicles(vehicle_id INTEGER PRIMARY KEY, customer_id INTEGER NOT NULL REFERENCES customers(customer_id), vin TEXT NOT NULL UNIQUE, make TEXT NOT NULL, model TEXT NOT NULL, year INTEGER CHECK(year BETWEEN 1900 AND 2100));
CREATE TABLE employees(employee_id INTEGER PRIMARY KEY, full_name TEXT NOT NULL, position TEXT NOT NULL);
CREATE TABLE services(service_id INTEGER PRIMARY KEY, name TEXT NOT NULL UNIQUE, standard_price NUMERIC NOT NULL CHECK(standard_price>=0));
CREATE TABLE repair_orders(order_id INTEGER PRIMARY KEY, vehicle_id INTEGER NOT NULL REFERENCES vehicles(vehicle_id), employee_id INTEGER NOT NULL REFERENCES employees(employee_id), opened_at TEXT NOT NULL, status TEXT NOT NULL CHECK(status IN ('принят','в работе','завершен')));
CREATE TABLE order_services(order_id INTEGER NOT NULL REFERENCES repair_orders(order_id), service_id INTEGER NOT NULL REFERENCES services(service_id), quantity INTEGER NOT NULL CHECK(quantity>0), unit_price NUMERIC NOT NULL CHECK(unit_price>=0), PRIMARY KEY(order_id,service_id));

CREATE TABLE parts(part_id INTEGER PRIMARY KEY, name TEXT NOT NULL, sku TEXT NOT NULL UNIQUE, stock_quantity INTEGER NOT NULL CHECK(stock_quantity>=0), price NUMERIC NOT NULL CHECK(price>=0));
CREATE TABLE order_parts(order_id INTEGER NOT NULL REFERENCES repair_orders(order_id), part_id INTEGER NOT NULL REFERENCES parts(part_id), quantity INTEGER NOT NULL CHECK(quantity>0), unit_price NUMERIC NOT NULL CHECK(unit_price>=0), PRIMARY KEY(order_id,part_id));
CREATE TABLE payments(payment_id INTEGER PRIMARY KEY, order_id INTEGER NOT NULL REFERENCES repair_orders(order_id), paid_at TEXT NOT NULL, amount NUMERIC NOT NULL CHECK(amount>0), method TEXT NOT NULL);

INSERT INTO customers VALUES (1,'Иванов Алексей','+7 900 100-00-01'),(2,'Петрова Мария','+7 900 100-00-02'),(3,'Сидоров Павел','+7 900 100-00-03');
INSERT INTO vehicles VALUES (1,1,'XTA00000000000001','Lada','Vesta',2020),(2,2,'XTA00000000000002','Kia','Rio',2019),(3,3,'XTA00000000000003','Hyundai','Solaris',2021);
INSERT INTO employees VALUES (1,'Кузнецов Илья','мастер-приемщик'),(2,'Орлов Максим','мастер-приемщик');
INSERT INTO services VALUES (1,'Диагностика',1500),(2,'Замена масла',1200),(3,'Замена тормозных колодок',2500);
INSERT INTO repair_orders VALUES (1,1,1,'2026-10-01','завершен'),(2,2,1,'2026-10-03','в работе'),(3,3,2,'2026-10-05','принят');
INSERT INTO order_services VALUES (1,1,1,1500),(1,2,1,1200),(2,3,1,2500),(3,1,1,1500);
INSERT INTO parts VALUES (1,'Масляный фильтр','FIL-01',15,500),(2,'Масло моторное 1 л','OIL-01',40,800),(3,'Колодки тормозные','BRA-01',8,3000);
INSERT INTO order_parts VALUES (1,1,1,500),(1,2,4,800),(2,3,1,3000);
INSERT INTO payments VALUES (1,1,'2026-10-01',6400,'карта'),(2,2,'2026-10-03',2000,'наличные');