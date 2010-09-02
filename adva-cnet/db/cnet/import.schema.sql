CREATE TABLE products (
  id                        SERIAL PRIMARY KEY UNIQUE,
  product_id                INTEGER,
  category_id               INTEGER,
  manufacturer_id           INTEGER,
  product_number            VARCHAR(40),
  manufacturer_part_number  VARCHAR(40),
  status                    VARCHAR(4),
  cat_id                    CHAR(2),
  mkt_id                    VARCHAR(10),
  img_id                    VARCHAR(10),
  mf_id                     VARCHAR(10),
  created_at                TIMESTAMP,
  updated_at                TIMESTAMP
);
