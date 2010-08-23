create table products (
  id                        INTEGER PRIMARY KEY ASC,
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
  created_at                VARCHAR(20),
  updated_at                VARCHAR(20)
);