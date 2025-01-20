SELECT
    o.order_id,
    i.item_price,
    o.quantity,
    i.item_cat,
    i.item_name,
    o.created_at,
    a.delivery_address1,
    a.delivery_address2,
    a.delivery_city,
    a.delivery_zipcode,
    o.delivery
FROM [order] o
LEFT JOIN item i 
    ON o.item_id = i.item_id
LEFT JOIN address a
    ON o.add_id = a.add_id;



-- total quantity by ingredient (no of orders * ingredient quantity in recipe)

select 
o.item_id, i.sku, i.item_name, sum(o.quantity) as order_quantity
from [order] o
left join item i 
on o.item_id=i.item_id
group by o.item_id, i.sku, i.item_name --add all the non aggregation columns

select 
o.item_id, i.sku, i.item_name, r.ing_id, ing.ing_name, r.quantity AS recipe_quantity, sum(o.quantity) as order_quantity
from [order] o
left join item i on o.item_id=i.item_id
LEFT JOIN recipe r ON i.sku = r.recipe_id
left join ingredient ing ON ing.ing_id = r.ing_id
group by o.item_id, i.sku, i.item_name, r.ing_id, r.quantity, ing.ing_name; --add all the non aggregation columns



--total cost of each ingredient
select 
s1.item_name,
s1.ing_id,
s1.ing_name,
s1.ing_weight,
s1.ing_price,
s1.order_quantity,
s1.recipe_quantity * s1.recipe_quantity as ordered_weight,
s1.ing_price/s1.ing_weight as unit_cost,
(s1.order_quantity*s1.recipe_quantity)*(s1.ing_price/s1.ing_weight) as ingredient_cost
from  (select 
o.item_id, i.sku, i.item_name, r.ing_id,ing.ing_name, r.quantity AS recipe_quantity, sum(o.quantity) as order_quantity, ing.ing_weight, ing.ing_price
from [order] o
left join item i 
on o.item_id=i.item_id
left join recipe r
on i.sku = r.recipe_id
left join ingredient ing 
on ing.ing_id = r.ing_id --order of joins dont matter
group by o.item_id, i.sku, i.item_name, r.ing_id, r.quantity, ing.ing_name, ing.ing_weight, ing.ing_price) s1


CREATE VIEW stock1 AS
SELECT 
    s1.item_name,
    s1.ing_id,
    s1.ing_name,
    s1.ing_weight,
    s1.ing_price,
    s1.order_quantity,
    s1.order_quantity * s1.recipe_quantity AS ordered_weight,
    s1.ing_price / s1.ing_weight AS unit_cost,
    (s1.order_quantity * s1.recipe_quantity) * (s1.ing_price / s1.ing_weight) AS ingredient_cost
FROM  
    (SELECT 
         o.item_id, 
         i.sku, 
         i.item_name, 
         r.ing_id, 
         ing.ing_name, 
         r.quantity AS recipe_quantity, 
         SUM(o.quantity) AS order_quantity, 
         ing.ing_weight, 
         ing.ing_price
     FROM 
         [order] o
     LEFT JOIN 
         item i 
     ON 
         o.item_id = i.item_id
     LEFT JOIN 
         recipe r
     ON 
         i.sku = r.recipe_id
     LEFT JOIN 
         ingredient ing 
     ON 
         ing.ing_id = r.ing_id
     GROUP BY 
         o.item_id, 
         i.sku, 
         i.item_name, 
         r.ing_id, 
         r.quantity, 
         ing.ing_name, 
         ing.ing_weight, 
         ing.ing_price
    ) s1;

-- total weight ordered
SELECT
s2.ing_name,
s2.ordered_weight,
ing.ing_weight*inv.quantity as total_inv_weight,
(ing.ing_weight * inv.quantity)-s2.ordered_weight as remainging_weight

FROM(select ing_id, ing_name, sum(ordered_weight) AS ordered_weight
FROM stock1
group by ing_name, ing_id)s2

left join inventory inv ON inv.item_id = s2.ing_id
--total wight in stock = ingredient quantity * ingredient weight
left join ingredient ing on ing.ing_id = s2.ing_id


-- staff costs and hours worked by period and staff member

SELECT
    r.date,
    s.first_name,
    s.last_name,
    s.hourly_rate,
    sh.start_time,
    sh.end_time,
    DATEDIFF(MINUTE, sh.start_time, sh.end_time) / 60.0 AS hours_in_shift, -- Calculate hours as decimal
    (DATEDIFF(MINUTE, sh.start_time, sh.end_time) / 60.0) * s.hourly_rate AS staff_cost -- Calculate cost
FROM 
    rota r 
LEFT JOIN 
    staff s ON r.staff_id = s.staff_id
LEFT JOIN 
    shift sh ON r.shift_id = sh.shift_id;


--timediff() function for h


