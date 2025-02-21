-- Create table
CREATE TABLE crypto_prices (
    timestamp TIMESTAMP NOT NULL,
    asset VARCHAR(10) NOT NULL,
    open DECIMAL(18,8) NOT NULL,
    high DECIMAL(18,8) NOT NULL,
    low DECIMAL(18,8) NOT NULL,
    close DECIMAL(18,8) NOT NULL,
    volume DECIMAL(18,2) NOT NULL,
    marketCap DECIMAL(18,2) NOT NULL,
    PRIMARY KEY (timestamp, asset)
);

CREATE TABLE sp500_prices (
    timestamp TIMESTAMP NOT NULL,
    asset TEXT NOT NULL,
    open NUMERIC(18,6),
    high NUMERIC(18,6),
    low NUMERIC(18,6),
    close NUMERIC(18,6),
    change_percent NUMERIC(10,4)
);

-- change table column
ALTER TABLE crypto_prices
ALTER COLUMN open TYPE NUMERIC(10,2),
ALTER COLUMN high TYPE NUMERIC(10,2),
ALTER COLUMN low TYPE NUMERIC(10,2),
ALTER COLUMN close TYPE NUMERIC(10,2);


DROP TABLE crypto_prices;

-- Input CSV file to table
COPY crypto_prices(timestamp, asset, open, high, low, close, volume, marketCap)
FROM 'C:\Users\User\OneDrive\Documents\Kuliah\Data Analyst Project\crypto_prices.csv'
DELIMITER ',' CSV HEADER;

COPY sp500_prices(timestamp, asset, open, high, low, close, change_percent)
FROM 'C:\Users\User\OneDrive\Documents\Kuliah\Data Analyst Project\SnP500Index_prices.csv'
DELIMITER ',' CSV HEADER;

-- check duplicates
SELECT timestamp, asset, COUNT(*) 
FROM crypto_prices 
GROUP BY timestamp, asset 
HAVING COUNT(*) > 1;

-- check Volatility
SELECT asset, 
        round(AVG(CASE 
               WHEN low > 0 THEN (high - low) / low * 100 
               ELSE NULL 
           END),2) AS avg_volatility_pct
FROM crypto_prices
WHERE low IS NOT NULL
GROUP BY asset
ORDER BY avg_volatility_pct DESC;


/*check Market cycle
Bullish Market = up_days_in_week ≥ 5 (e.g., BTC has 6 up days).
Bearish Market = up_days_in_week ≤ 2 (e.g., ETH has only 2 up days).
Neutral Market = 3 ≤ up_days_in_week ≤ 4 (e.g., ADA has 4 up days).*/
WITH price_changes AS (
    SELECT asset, 
           timestamp, 
           close, 
           LAG(close) OVER (PARTITION BY asset ORDER BY timestamp) AS previous_close
    FROM crypto_prices
)
SELECT asset, 
       timestamp, 
       close, 
       ROUND(close - COALESCE(previous_close, close), 2) AS price_change,
       ROUND((close - COALESCE(previous_close, close)) / COALESCE(previous_close, close) * 100, 2) AS daily_return,
       SUM(
        CASE WHEN 
            close > COALESCE(previous_close, close) 
            THEN 1 
            ELSE 0 
        END) 
           OVER (PARTITION BY asset ORDER BY timestamp ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS up_days_in_week
FROM price_changes;

-- correlation btc against snp
WITH price_data AS (
    SELECT c.timestamp, 
           c.close AS btc_price, 
           s.close AS snp500_price
    FROM crypto_prices c
    JOIN sp500_prices s 
    ON c.timestamp = s.timestamp
    WHERE c.asset = 'BTC'
),
correlation_data AS (
    SELECT timestamp, 
           CORR(btc_price, snp500_price) 
               OVER (ORDER BY timestamp ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS correlation
    FROM price_data
)

SELECT timestamp,
       correlation,
       CASE 
           WHEN correlation >= 0.5 THEN '📈 BTC follows stock market'
           WHEN correlation <= -0.5 THEN '🔄 BTC moves opposite to stock market'
           ELSE '⚖️ BTC independent'
       END AS market_trend
FROM correlation_data
WHERE correlation IS NOT NULL
ORDER BY timestamp;


