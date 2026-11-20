-- Заказы и владельцы
SELECT o.order_id,c.full_name,v.make,v.model,o.status FROM repair_orders o JOIN vehicles v ON v.vehicle_id=o.vehicle_id JOIN customers c ON c.customer_id=v.customer_id ORDER BY o.order_id;

-- Стоимость работ по заказам
SELECT o.order_id, COALESCE(SUM(s.quantity*s.unit_price),0) AS labor_total FROM repair_orders o LEFT JOIN order_services s ON s.order_id=o.order_id GROUP BY o.order_id ORDER BY o.order_id;

-- Открытые заказы
SELECT order_id, opened_at, status FROM repair_orders WHERE status <> 'завершен' ORDER BY opened_at;

-- Популярность услуг
SELECT s.name,COALESCE(SUM(os.quantity),0) AS quantity FROM services s LEFT JOIN order_services os ON os.service_id=s.service_id GROUP BY s.service_id ORDER BY quantity DESC;

-- Остатки запчастей
SELECT name,stock_quantity FROM parts ORDER BY stock_quantity;

-- Баланс заказов
SELECT o.order_id, COALESCE((SELECT SUM(quantity*unit_price) FROM order_services WHERE order_id=o.order_id),0)+COALESCE((SELECT SUM(quantity*unit_price) FROM order_parts WHERE order_id=o.order_id),0) AS total, COALESCE((SELECT SUM(amount) FROM payments WHERE order_id=o.order_id),0) AS paid FROM repair_orders o ORDER BY o.order_id;