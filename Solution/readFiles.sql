

/*  ============================================
    Create table store_revenue, marketing_data
    ============================================ */

DROP TABLE IF EXISTS store_revenue;
create table store_revenue (
    date datetime, 
    brand_id int, 
    store_location varchar(250), 
    revenue float
);
SELECT * FROM store_revenue;

DROP TABLE IF EXISTS marketing_data;
create table marketing_data ( 
    date datetime, 
    geo varchar(2), 
    impressions float, 
    clicks float 
);
SELECT * FROM marketing_data;


/*  ============================================
    Insert data to table from csv file
    ============================================ */

/**** store_revenue ****/
TRUNCATE TABLE store_revenue;
BULK INSERT store_revenue
FROM '/store_revenue.csv'
WITH ( FORMAT='CSV', FIRSTROW=2 )
GO

SELECT * FROM store_revenue;

/**** marketing_data ****/
TRUNCATE TABLE marketing_data;
BULK INSERT marketing_data
FROM '/marketing_data.csv'
WITH ( FORMAT='CSV', FIRSTROW=2 )
GO

SELECT * FROM marketing_data;



