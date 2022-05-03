SELECT *
FROM dbo.Invistico_Airline
ORDER BY satisfaction

-- Select data to be used in the analysis

SELECT satisfaction, customer_type, type_of_travel, gender, age, flight_distance, departure_delay_in_minutes, arrival_delay_in_minutes
FROM dbo.Invistico_Airline
Order by satisfaction

-- Looking at customer gender and age to satisfaction

SELECT satisfaction, gender, age
FROM dbo.Invistico_Airline
Order by age desc

-- satisfaction ranking by age

SELECT age, COUNT('satisfaction') as satisfaction_ranking
FROM dbo.Invistico_Airline
Group by age
Order by age desc

-- Satisfaction per male and female

SELECT satisfaction, SUM(CASE WHEN gender = 'male' THEN 1 ELSE 0 END) AS male, SUM(CASE WHEN gender = 'female' THEN 1 ELSE 0 END) AS female
FROM dbo.Invistico_Airline
Group by satisfaction

-- Satisfaction per age group

SELECT satisfaction, SUM(CASE WHEN age < 20 THEN 1 ELSE 0 END) as under_twenety, SUM(CASE WHEN age between 20 and 40 THEN 1 ELSE 0 END) as twenety_to_fourty, SUM(CASE WHEN age between 41 and 60 THEN 1 ELSE 0 END) as fourty_to_sixty, SUM(CASE WHEN age between 61 and 80 THEN 1 ELSE 0 END) as sixty_to_eighty, SUM(CASE WHEN age > 81 THEN 1 ELSE 0 END) as over_eighty
FROM dbo.Invistico_Airline
Group by satisfaction

-- Satisfaction per minute delay

SELECT satisfaction, SUM(CASE WHEN arrival_delay_in_minutes is null THEN 1 ELSE 0 END) as no_delay, SUM(CASE WHEN arrival_delay_in_minutes < 30 THEN 1 ELSE 0 END) as less_than_thirty_min_delay, SUM(CASE WHEN arrival_delay_in_minutes between 31 and 60 THEN 1 ELSE 0 END) as thirty_to_hour_delay , SUM(CASE WHEN arrival_delay_in_minutes between 61 and 120 THEN 1 ELSE 0 END) as hour_to_two_hour_delay, SUM(CASE WHEN arrival_delay_in_minutes > 121 THEN 1 ELSE 0 END) as over_two_hour_delay
FROM dbo.Invistico_Airline
Group by satisfaction

-- Satisfaction per average departure delay time in minutes

SELECT satisfaction, AVG(departure_delay_in_minutes) as avergae_arrival_delay_in_minutes
FROM dbo.Invistico_Airline
Group by satisfaction

-- Satisfaction per flight distance in miles

SELECT satisfaction, SUM(CASE WHEN flight_distance < 500 THEN 1 ELSE 0 END) as less_than_five_hundred_mile_flight, SUM(CASE WHEN flight_distance between 501 and 1000 THEN 1 ELSE 0 END) as five_hundred_to_thousand_mile_flight , SUM(CASE WHEN flight_distance between 1001 and 3000 THEN 1 ELSE 0 END) as thousand_to_three_thousand_mile_flight, SUM(CASE WHEN flight_distance > 3001 THEN 1 ELSE 0 END) as over_three_thousand_mile_flight
FROM dbo.Invistico_Airline
Group by satisfaction

-- Satisfaction per average flight distance in miles

SELECT satisfaction, AVG(flight_distance) as average_flight_distance
FROM dbo.Invistico_Airline
Group by satisfaction

-- Satisfaction per type of travel

SELECT satisfaction, SUM(CASE WHEN type_of_travel = 'Business travel' THEN 1 ELSE 0 END) AS business_travel, SUM(CASE WHEN type_of_travel = 'Personal travel' THEN 1 ELSE 0 END) AS personal_travel
FROM dbo.Invistico_Airline
Group by satisfaction

-- Satisfaction per customer type

SELECT satisfaction, SUM(CASE WHEN customer_type = 'disloyal customer' THEN 1 ELSE 0 END) AS disloyal_customer, SUM(CASE WHEN customer_type = 'loyal customer' THEN 1 ELSE 0 END) AS loyal_customer
FROM dbo.Invistico_Airline
Group by satisfaction

-- Creating view to store data for later visualization

Create view satisfaction_per_customer_type as
SELECT satisfaction, SUM(CASE WHEN customer_type = 'disloyal customer' THEN 1 ELSE 0 END) AS disloyal_customer, SUM(CASE WHEN customer_type = 'loyal customer' THEN 1 ELSE 0 END) AS loyal_customer
FROM dbo.Invistico_Airline
Group by satisfaction

SELECT *
FROM satisfaction_per_customer_type
