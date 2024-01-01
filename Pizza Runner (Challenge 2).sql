-- Insert table
DROP TABLE IF EXISTS runners;

CREATE TABLE
  runners ("runner_id" INTEGER, "registration_date" DATE);

INSERT INTO
  runners ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');

DROP TABLE IF EXISTS customer_orders;

CREATE TABLE
  customer_orders (
    "order_id" INTEGER,
    "customer_id" INTEGER,
    "pizza_id" INTEGER,
    "exclusions" VARCHAR(4),
    "extras" VARCHAR(4),
    "order_time" DATETIME
  );

INSERT INTO
  customer_orders (
    "order_id",
    "customer_id",
    "pizza_id",
    "exclusions",
    "extras",
    "order_time"
  )
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  (
    '5',
    '104',
    '1',
    'null',
    '1',
    '2020-01-08 21:00:29'
  ),
  (
    '6',
    '101',
    '2',
    'null',
    'null',
    '2020-01-08 21:03:13'
  ),
  (
    '7',
    '105',
    '2',
    'null',
    '1',
    '2020-01-08 21:20:29'
  ),
  (
    '8',
    '102',
    '1',
    'null',
    'null',
    '2020-01-09 23:54:33'
  ),
  (
    '9',
    '103',
    '1',
    '4',
    '1, 5',
    '2020-01-10 11:22:59'
  ),
  (
    '10',
    '104',
    '1',
    'null',
    'null',
    '2020-01-11 18:34:49'
  ),
  (
    '10',
    '104',
    '1',
    '2, 6',
    '1, 4',
    '2020-01-11 18:34:49'
  );

DROP TABLE IF EXISTS runner_orders;

CREATE TABLE
  runner_orders (
    "order_id" INTEGER,
    "runner_id" INTEGER,
    "pickup_time" DATETIME,
    "distance" VARCHAR(7),
    "duration" VARCHAR(10),
    "cancellation" VARCHAR(23)
  );

INSERT INTO
  runner_orders (
    "order_id",
    "runner_id",
    "pickup_time",
    "distance",
    "duration",
    "cancellation"
  )
VALUES
  (
    '1',
    '1',
    '2020-01-01 18:15:34',
    '20km',
    '32 minutes',
    ''
  ),
  (
    '2',
    '1',
    '2020-01-01 19:10:54',
    '20km',
    '27 minutes',
    ''
  ),
  (
    '3',
    '1',
    '2020-01-03 00:12:37',
    '13.4km',
    '20 mins',
    NULL
  ),
  (
    '4',
    '2',
    '2020-01-04 13:53:03',
    '23.4',
    '40',
    NULL
  ),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  (
    '6',
    '3',
    NULL,
    'null',
    'null',
    'Restaurant Cancellation'
  ),
  (
    '7',
    '2',
    '2020-01-08 21:30:45',
    '25km',
    '25mins',
    'null'
  ),
  (
    '8',
    '2',
    '2020-01-10 00:15:02',
    '23.4 km',
    '15 minute',
    'null'
  ),
  (
    '9',
    '2',
    NULL,
    'null',
    'null',
    'Customer Cancellation'
  ),
  (
    '10',
    '1',
    '2020-01-11 18:50:20',
    '10km',
    '10minutes',
    'null'
  );

DROP TABLE IF EXISTS pizza_names;

CREATE TABLE
  pizza_names ("pizza_id" INTEGER, "pizza_name" TEXT);

INSERT INTO
  pizza_names ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');

DROP TABLE IF EXISTS pizza_recipes;

CREATE TABLE
  pizza_recipes ("pizza_id" INTEGER, "toppings" TEXT);

INSERT INTO
  pizza_recipes ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');

DROP TABLE IF EXISTS pizza_toppings;

CREATE TABLE
  pizza_toppings ("topping_id" INTEGER, "topping_name" TEXT);

INSERT INTO
  pizza_toppings ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');

--Clean data
UPDATE customer_orders
SET
  exclusions = NULL
WHERE
  exclusions = 'null'
  or exclusions = '';

UPDATE customer_orders
SET
  extras = NULL
WHERE
  extras = 'null'
  or extras = '';

UPDATE runner_orders
SET
  cancellation = NULL
WHERE
  cancellation = 'null'
  or cancellation = '';

UPDATE runner_orders
SET
  distance = TRIM(REPLACE (distance, 'km', ''));

UPDATE runner_orders
SET
  distance = NULL
WHERE
  distance = 'null'
  or distance = '';

UPDATE runner_orders
SET
  duration = TRIM(
    REPLACE (
      REPLACE (REPLACE (duration, 'minutes', ''), 'minute', ''),
      'mins',
      ''
    )
  );

UPDATE runner_orders
SET
  duration = NULL
WHERE
  duration = 'null'
  or duration = '';

--A. Pizza Metrics
--How many pizzas were ordered?
SELECT
  COUNT(order_id) as Pizza_Orders
FROM
  customer_orders;

--How many unique customer orders were made?
SELECT
  COUNT(DISTINCT order_id) as Unique_Pizza_Orders
FROM
  customer_orders;

--How many successful orders were delivered by each runner?
SELECT
  runner_id,
  COUNT(runner_id) as Successful_Orders
FROM
  runner_orders
WHERE
  pickup_time is not null
GROUP BY
  runner_id;

--How many of each type of pizza was delivered?
SELECT
  pizza_name,
  COUNT(pizza_name) AS pizza_count
FROM
  (
    SELECT
      CAST(pizz.pizza_name AS NVARCHAR (MAX)) AS pizza_name
    FROM
      customer_orders cust
      JOIN runner_orders runn ON cust.order_id = runn.order_id
      JOIN pizza_names pizz ON pizz.pizza_id = cust.pizza_id
    WHERE
      pickup_time is not NULL
  ) as myQry
GROUP BY
  pizza_name;

--How many Vegetarian and Meatlovers were ordered by each customer?
SELECT
  customer_id,
  pizza_name,
  COUNT(pizza_name) AS pizza_count
FROM
  (
    SELECT
      CAST(pizz.pizza_name AS NVARCHAR (MAX)) AS pizza_name,
      cust.customer_id
    FROM
      customer_orders cust
      JOIN pizza_names pizz ON pizz.pizza_id = cust.pizza_id
  ) as myQry
GROUP BY
  customer_id,
  pizza_name
ORDER BY
  customer_id;

--What was the maximum number of pizzas delivered in a single order?
SELECT
  MAX(Deliveries) as Max_Deliveries
FROM
  (
    SELECT
      order_id,
      COUNT(order_id) as Deliveries
    FROM
      customer_orders
    GROUP BY
      order_id
  ) as Dlv;

--For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
--Pizzas with at least one change
SELECT
  customer_id,
  COUNT(pizza_id) as Changed_Pizza
FROM
  customer_orders
WHERE
  exclusions is NOT NULL
  or extras is NOT NULL
GROUP BY
  customer_id;

--Pizzas with no change
SELECT
  customer_id,
  COUNT(pizza_id) as Changed_Pizza
FROM
  customer_orders
WHERE
  exclusions is NULL
  and extras is NULL
GROUP BY
  customer_id;

--How many pizzas were delivered that had both exclusions and extras?
SELECT
  COUNT(pizza_id) as Changed_Pizza
FROM
  customer_orders
WHERE
  exclusions is NOT NULL
  and extras is NOT NULL;

--What was the total volume of pizzas ordered for each hour of the day?
SELECT
  DATEPART (HOUR, order_time) AS Hour_of_day,
  COUNT(pizza_id) AS Total_pizzas_ordered
FROM
  customer_orders
GROUP BY
  DATEPART (HOUR, order_time)
ORDER BY
  Hour_of_day;

--What was the volume of orders for each day of the week?
SELECT
  DATEPART (WEEKDAY, order_time) AS Day_of_week,
  COUNT(pizza_id) AS Total_pizzas_ordered
FROM
  customer_orders
GROUP BY
  DATEPART (WEEKDAY, order_time)
ORDER BY
  Day_of_week;

--B. Runner and Customer Experience
--How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT
  DATEPART (WEEK, registration_date) as Week_Period,
  COUNT(runner_id) as Sign_ups
FROM
  runners
GROUP BY
  DATEPART (WEEK, registration_date)
ORDER BY
  Week_Period;

--What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
SELECT
  runner_id,
  AVG(DATEDIFF (MINUTE, order_time, pickup_time)) as Average_Time_in_minutes
FROM
  customer_orders cus
  JOIN runner_orders run ON cus.order_id = run.order_id
WHERE
  order_time is not null
  and pickup_time is not null
GROUP BY
  runner_id;

--Is there any relationship between the number of pizzas and how long the order takes to prepare?
SELECT
  Number_Of_Pizzas,
  AVG(Average_Time_in_minutes) as Duration
FROM
  (
    SELECT
      order_id,
      COUNT(order_id) as Number_Of_Pizzas
    FROM
      customer_orders
    GROUP BY
      order_id
  ) as num_of_pizza_table
  JOIN (
    SELECT
      cus.order_id,
      AVG(DATEDIFF (MINUTE, order_time, pickup_time)) as Average_Time_in_minutes
    FROM
      customer_orders cus
      JOIN runner_orders run ON cus.order_id = run.order_id
    WHERE
      order_time is not null
      and pickup_time is not null
    GROUP BY
      cus.order_id
  ) AS Avg_Time_Table ON num_of_pizza_table.order_id = Avg_Time_Table.order_id
GROUP BY
  Number_Of_Pizzas;

--According to the data, there is a relationship between the number of pizzas and how long 
--the order takes to prepare as we can see from the increase in the average duration as the number of pizzas increases
--What was the average distance travelled for each customer?
SELECT
  customer_id,
  AVG(CAST(distance as FLOAT)) AS Avg_Distance
FROM
  runner_orders run
  JOIN customer_orders cus ON run.order_id = cus.order_id
GROUP BY
  customer_id
ORDER BY
  Avg_Distance;

--What was the difference between the longest and shortest delivery times for all orders?
SELECT
  (
    MAX(CAST(duration AS int)) - MIN(CAST(duration AS int))
  ) as Range_Difference
FROM
  runner_orders;

--What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT
  runner_id,
  run.order_id,
  COUNT(pizza_id) as Number_Of_Pizzas,
  ROUND(
    AVG(
      CAST(distance AS float) / (CAST(duration as float) / 60)
    ),
    0
  ) as Speed
FROM
  runner_orders run
  JOIN customer_orders cus ON run.order_id = cus.order_id
WHERE
  duration is not null
  and distance is not null
GROUP BY
  runner_id,
  run.order_id
ORDER BY
  Speed DESC;

--What is the successful delivery percentage for each runner?
SELECT
  CAST(
    (
      CAST(
        COUNT(
          CASE
            WHEN cancellation IS NULL THEN 1
          END
        ) AS DECIMAL(5, 2)
      ) / CAST(COUNT(runner_id) AS DECIMAL(5, 2))
    ) * 100 AS INT
  ) as Successful_Deliveries,
  runner_id
FROM
  runner_orders
GROUP BY
  runner_id;

--C. Ingredient Optimisation
--What are the standard ingredients for each pizza?
select
  CAST(pizza_name AS VARCHAR(MAX)) AS Pizza,
  STRING_AGG (CAST(topping_name AS VARCHAR(MAX)), ', ') AS Ingredients
from
  (
    SELECT
      pizza_id,
      TRIM(value) AS topping
    FROM
      pizza_recipes CROSS APPLY STRING_SPLIT (CAST(toppings AS VARCHAR(MAX)), ',')
  ) AS Split_Tops
  JOIN pizza_toppings ON Split_Tops.topping = pizza_toppings.topping_id
  JOIN pizza_names ON pizza_names.pizza_id = Split_Tops.pizza_id
GROUP BY
  CAST(pizza_name AS VARCHAR(MAX));

--What was the most commonly added extra?
SELECT
  topping_name AS Most_Common_Extra,
  Count
FROM
  pizza_toppings topp
  JOIN (
    SELECT
      TRIM(value) as Extra,
      COUNT(TRIM(value)) AS 'Count'
    FROM
      customer_orders CROSS APPLY string_split (extras, ',')
    GROUP BY
      value
  ) AS Count_Tbl ON topp.topping_id = Count_Tbl.Extra
ORDER BY
  Count DESC;

--What was the most common exclusion?
SELECT
  topping_name AS Most_Common_Exclusion,
  Count
FROM
  pizza_toppings topp
  JOIN (
    SELECT
      TRIM(value) as Exc,
      COUNT(TRIM(value)) as 'Count'
    FROM
      customer_orders CROSS APPLY string_split (CAST(exclusions as VARCHAR(MAX)), ',')
    GROUP BY
      value
  ) as Count_Tbl ON topp.topping_id = Count_Tbl.Exc
ORDER BY
  Count DESC;

--Generate an order item for each record in the customers_orders table in the format of one of the following:
--Meat Lovers
--Meat Lovers - Exclude Beef
--Meat Lovers - Extra Bacon
--Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
WITH
  OrderDetails AS (
    SELECT
      co.order_id,
      co.customer_id,
      co.pizza_id,
      CAST(pn.pizza_name AS VARCHAR(MAX)) as pizza_name,
      co.exclusions,
      co.extras
    FROM
      customer_orders co
      JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
  )
SELECT
  order_id,
  customer_id,
  pizza_id,
  pizza_name,
  CASE
    WHEN exclusions IS NULL
    AND extras IS NULL THEN pizza_name
    WHEN exclusions IS NULL THEN pizza_name + ' - Extra ' + STRING_AGG (
      CAST(pt_toppings.topping_name AS VARCHAR(MAX)),
      ', '
    )
    WHEN extras IS NULL THEN pizza_name + ' - Exclude ' + STRING_AGG (
      CAST(pt_exclusions.topping_name AS VARCHAR(MAX)),
      ', '
    )
    ELSE pizza_name + ' - Exclude ' + STRING_AGG (
      CAST(pt_exclusions.topping_name AS VARCHAR(MAX)),
      ', '
    ) + ' - Extra ' + STRING_AGG (
      CAST(pt_toppings.topping_name AS VARCHAR(MAX)),
      ', '
    )
  END AS order_item
FROM
  OrderDetails OUTER APPLY STRING_SPLIT (OrderDetails.exclusions, ',') exclusions_split OUTER APPLY STRING_SPLIT (OrderDetails.extras, ',') extras_split
  LEFT JOIN pizza_toppings pt_exclusions ON TRY_CAST (exclusions_split.value AS INT) = pt_exclusions.topping_id
  LEFT JOIN pizza_toppings pt_toppings ON TRY_CAST (extras_split.value AS INT) = pt_toppings.topping_id
GROUP BY
  order_id,
  customer_id,
  pizza_id,
  pizza_name,
  exclusions,
  extras;

--Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
--For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
WITH
  Comb_Table AS (
    SELECT
      order_id,
      customer_id,
      cus.pizza_id,
      CASE
        WHEN exclusions is null
        and extras is null THEN toppings
        WHEN exclusions is null THEN CAST(toppings AS VARCHAR(MAX)) + ', ' + CAST(extras AS VARCHAR(MAX))
        WHEN extras is null THEN CAST(toppings AS VARCHAR(MAX)) + ', ' + CAST(exclusions AS VARCHAR(MAX))
        WHEN exclusions is not null
        and extras is not null then CAST(toppings AS VARCHAR(MAX)) + ', ' + CAST(extras AS VARCHAR(MAX)) + ', ' + CAST(exclusions AS VARCHAR(MAX))
      END as Combination
    FROM
      customer_orders cus
      JOIN pizza_recipes rec ON cus.pizza_id = rec.pizza_id
  )
SELECT
  order_id,
  CAST(pizza_name AS VARCHAR(MAX)) as pzz_name,
  (
    CAST(pizza_name AS VARCHAR(MAX)) + ': ' + STRING_AGG (
      CASE
        WHEN Topp_Count > 1 THEN CAST(Topp_Count AS VARCHAR(MAX)) + 'x' + CAST(topping_name AS VARCHAR(MAX))
        ELSE CAST(topping_name AS VARCHAR(MAX))
      END,
      ', '
    ) WITHIN GROUP (
      ORDER BY
        order_id
    )
  ) AS 'Output'
FROM
  pizza_toppings ptp
  JOIN (
    SELECT DISTINCT
      order_id,
      pizza_id,
      top_split.value as Topp,
      COUNT(top_split.value) OVER (
        PARTITION BY
          order_id,
          TRIM(top_split.value)
      ) AS Topp_Count
    FROM
      Comb_Table com OUTER APPLY string_split (CAST(Combination AS VARCHAR(MAX)), ',') top_split
  ) AS all_toppings ON ptp.topping_id = TRIM(all_toppings.Topp)
  JOIN pizza_names pnm ON pnm.pizza_id = all_toppings.pizza_id
GROUP BY
  order_id,
  CAST(pizza_name AS VARCHAR(MAX))
ORDER BY
  order_id;

--What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
WITH
  Combined_Table AS (
    SELECT
      order_id,
      cus.pizza_id,
      cus.customer_id,
      CASE
        WHEN extras is null
        and exclusions is null THEN CAST(toppings AS VARCHAR(MAX))
        WHEN extras is null then CAST(toppings AS VARCHAR(MAX)) + ', ' + CAST(exclusions AS VARCHAR(MAX))
        WHEN exclusions is null then CAST(toppings AS VARCHAR(MAX)) + ', ' + CAST(extras AS VARCHAR(MAX))
        WHEN extras is not null
        and exclusions is not null THEN CAST(toppings AS VARCHAR(MAX)) + ', ' + CAST(exclusions AS VARCHAR(MAX)) + ', ' + CAST(extras AS VARCHAR(MAX))
      END as Ingredients
    FROM
      customer_orders cus
      JOIN pizza_recipes prp ON cus.pizza_id = prp.pizza_id
  )
SELECT
  order_id,
  customer_id,
  pizza_name,
  topping_name,
  Count
FROM
  (
    SELECT DISTINCT
      order_id,
      customer_id,
      CAST(pizza_name AS VARCHAR(MAX)) as pizza_name,
      TRIM(Individual_Ingredients.value) as Ingredient,
      COUNT(TRIM(Individual_Ingredients.value)) OVER (
        PARTITION BY
          TRIM(Individual_Ingredients.value),
          order_id
        ORDER BY
          TRY_CAST (TRIM(Individual_Ingredients.value) AS INT)
      ) as 'Count'
    FROM
      Combined_Table com
      JOIN pizza_names pnm ON com.pizza_id = pnm.pizza_id OUTER APPLY string_split (CAST(Ingredients AS VARCHAR(MAX)), ',') as Individual_Ingredients
  ) as SubQuery
  JOIN pizza_toppings ptp ON ptp.topping_id = SubQuery.Ingredient
ORDER BY
  order_id,
  customer_id,
  pizza_name,
  Count DESC;

--D. Pricing and Ratings
--If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
SELECT
  COUNT(Tbl.order_id) as Total_Deliveries,
  SUM(
    CASE
      WHEN CAST(Tbl.pizza_name AS VARCHAR(MAX)) = 'Meatlovers' THEN 12
      WHEN CAST(Tbl.pizza_name AS VARCHAR(MAX)) = 'Vegetarian' THEN 10
    END
  ) as Total_Price
FROM
  (
    SELECT DISTINCT
      cus.order_id,
      CAST(pizza_name AS VARCHAR(MAX)) as pizza_name,
      customer_id,
      extras
    FROM
      customer_orders cus
      JOIN pizza_names pnm ON cus.pizza_id = pnm.pizza_id
      JOIN runner_orders ror ON cus.order_id = ror.order_id
    WHERE
      cancellation is null
  ) AS Tbl;

--What if there was an additional $1 charge for any pizza extras?
WITH
  Price_Tbl AS (
    SELECT DISTINCT
      cus.order_id,
      cus.pizza_id,
      customer_id,
      extras,
      CASE
        WHEN CAST(pizza_name AS VARCHAR(MAX)) = 'Meatlovers' THEN 12
        WHEN CAST(pizza_name AS VARCHAR(MAX)) = 'Vegetarian' THEN 10
      END as Price,
      SUM(
        CASE
          WHEN value is NOT NULL THEN 1
        END
      ) OVER (
        PARTITION BY
          extras
      ) as extra_price
    FROM
      customer_orders cus
      JOIN pizza_names pnm ON cus.pizza_id = pnm.pizza_id
      JOIN runner_orders ror ON cus.order_id = ror.order_id OUTER APPLY string_split (CAST(extras AS VARCHAR(MAX)), ',')
    WHERE
      cancellation is null
  )
SELECT
  COUNT(order_id) AS Total_Deliveries,
  (SUM(Price) + SUM(extra_price)) AS Total_Made
FROM
  Price_Tbl;

--Add cheese is $1 extra
WITH
  PriceTbl AS (
    SELECT DISTINCT
      order_id,
      pizza_id,
      customer_id,
      extras,
      CASE
        WHEN CAST(pizza_name AS VARCHAR(MAX)) = 'Meatlovers' THEN 12
        WHEN CAST(pizza_name AS VARCHAR(MAX)) = 'Vegetarian' THEN 10
      END as Price,
      SUM(
        CASE
          WHEN Ing is NOT NULL
          AND topping_name like 'Cheese' THEN 1
        END
      ) OVER (
        PARTITION BY
          extras
      ) as extra_price
    FROM
      (
        SELECT DISTINCT
          cus.order_id,
          cus.pizza_id,
          customer_id,
          extras,
          CAST(pizza_name AS VARCHAR(MAX)) as pizza_name,
          TRIM(value) as Ing
        FROM
          customer_orders cus
          JOIN pizza_names pnm ON cus.pizza_id = pnm.pizza_id
          JOIN runner_orders ror ON cus.order_id = ror.order_id OUTER APPLY string_split (CAST(extras AS VARCHAR(MAX)), ',')
        WHERE
          cancellation is null
      ) AS Tbl
      LEFT JOIN pizza_toppings ptp ON TRIM(Tbl.Ing) = ptp.topping_id
  )
SELECT
  COUNT(order_id) AS Total_Deliveries,
  (SUM(Price) + SUM(extra_price)) AS Total_Made
FROM
  PriceTbl;

--The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
CREATE TABLE
  order_rating (
    order_id int,
    runner_id int,
    rating int CHECK (rating in (1, 2, 3, 4, 5))
  )
INSERT INTO
  order_rating (order_id, runner_id, rating)
SELECT
  order_id,
  runner_id,
  CASE
    WHEN duration < 11 THEN 5
    WHEN duration > 10
    AND duration < 21 THEN 4
    WHEN duration > 20
    AND duration < 31 THEN 3
    WHEN duration > 30
    AND duration < 41 THEN 2
    WHEN duration > 40 THEN 1
    WHEN duration IS NULL THEN NULL
  END AS rating
FROM
  runner_orders;

--Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
--customer_id
--order_id
--runner_id
--rating
--order_time
--pickup_time
--Time between order and pickup
--Delivery duration
--Average speed
--Total number of pizzas
SELECT
  cus.customer_id,
  cus.order_id,
  run.runner_id,
  ort.rating,
  cus.order_time,
  run.pickup_time,
  DATEDIFF (MINUTE, cus.order_time, run.pickup_time) as Time_btw,
  run.duration,
  ROUND(
    CAST(run.distance AS float) / (CAST(run.duration as float) / 60),
    0
  ) as Average_speed,
  COUNT(*) OVER () AS total_pizzas
FROM
  customer_orders cus
  JOIN runner_orders run ON cus.order_id = run.order_id
  JOIN order_rating ort ON cus.order_id = ort.order_id
WHERE
  cancellation is null;

--If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
SELECT
  cus.order_id,
  pizza_name,
  CASE
    WHEN pizza_name LIKE 'Meatlovers' THEN ROUND(12 - (0.30 * CAST(distance as float)), 2)
    WHEN pizza_name LIKE 'Vegetarian' THEN ROUND(10 - (0.30 * CAST(distance as float)), 2)
  END as Profit
FROM
  customer_orders cus
  JOIN runner_orders run ON cus.order_id = run.order_id
  JOIN pizza_names pnm ON cus.pizza_id = pnm.pizza_id
WHERE
  cancellation is null;