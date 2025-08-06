CREATE DATABASE ab_testing_project;

USE ab_testing_project;
SHOW tables;
select * from control_group;
select * from test_group;

CREATE TABLE ab_campaign_data AS
SELECT 
    'control' AS group_type,
    `Campaign Name`,
    `Date`,
    `Spend [USD]`,
    `# of Impressions`,
    `Reach`,
    `# of Website Clicks`,
    `# of Searches`,
    `# of View Content`,
    `# of Add to Cart`,
    `# of Purchase`
FROM control_group
UNION ALL
SELECT 
    'test' AS group_type,
    `Campaign Name`,
    `Date`,
    `Spend [USD]`,
    `# of Impressions`,
    `Reach`,
    `# of Website Clicks`,
    `# of Searches`,
    `# of View Content`,
    `# of Add to Cart`,
    `# of Purchase`
FROM test_group;


select * from ab_campaign_data;






ALTER TABLE ab_campaign_data
CHANGE `Spend [USD]` spend_usd INT,
CHANGE `# of Impressions` impressions INT,

CHANGE `# of Website Clicks` website_clicks INT,
CHANGE `# of Searches` searches INT,
CHANGE `# of View Content` view_content INT,
CHANGE `# of Add to Cart` add_to_cart INT,
CHANGE `# of Purchase` purchase INT;


SELECT DISTINCT `# of Purchase` 
FROM ab_campaign_data;

UPDATE ab_campaign_data 
SET `# of Purchase` = 0 
WHERE TRIM(`# of Purchase`) = '' OR `# of Purchase` IS NULL;

UPDATE ab_campaign_data 
SET `# of Impressions` = 0 
WHERE TRIM(`# of Impressions`) = '' OR `# of Impressions` IS NULL;

UPDATE ab_campaign_data 
SET `# of Website Clicks` = 0 
WHERE TRIM(`# of Website Clicks`) = '' OR `# of Website Clicks` IS NULL;

UPDATE ab_campaign_data 
SET `# of Searches` = 0 
WHERE TRIM(`# of Searches`) = '' OR `# of Searches` IS NULL;

UPDATE ab_campaign_data 
SET `# of View Content` = 0 
WHERE TRIM(`# of View Content`) = '' OR `# of View Content` IS NULL;

UPDATE ab_campaign_data 
SET `# of Add to Cart` = 0 
WHERE TRIM(`# of Add to Cart`) = '' OR `# of Add to Cart` IS NULL;

UPDATE ab_campaign_data 
SET `Reach` = 0 
WHERE TRIM(`Reach`) = '' OR `Reach` IS NULL;





ALTER TABLE ab_campaign_data 
MODIFY `# of Purchase` INT,
MODIFY `# of Impressions` INT,
MODIFY `# of Website Clicks` INT,
MODIFY `# of Searches` INT,
MODIFY `# of View Content` INT,
MODIFY `# of Add to Cart` INT;

ALTER TABLE ab_campaign_data 
MODIFY `Reach` INT;

ALTER TABLE ab_campaign_data
MODIFY `Spend [USD]` FLOAT;


ALTER TABLE ab_campaign_data
CHANGE `Campaign Name` campaign_name VARCHAR(255),
CHANGE `Date` campaign_date DATE,
CHANGE `Spend [USD]` spend_usd FLOAT,
CHANGE `# of Impressions` impressions INT,
CHANGE `Reach` reach INT,
CHANGE `# of Website Clicks` website_clicks INT,
CHANGE `# of Searches` searches INT,
CHANGE `# of View Content` view_content INT,
CHANGE `# of Add to Cart` add_to_cart INT,
CHANGE `# of Purchase` purchase INT;




USE ab_testing_project;
select * from ab_campaign_data