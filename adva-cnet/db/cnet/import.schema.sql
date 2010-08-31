CREATE TABLE cnet_attributes (
  ext_category_id           char(2),
  ext_value_id              varchar(78),
  section_name              varchar(2000),
  key_name                  varchar(2000),
  numeric_value             float(53),
  unit                      varchar(255),
  display_value             varchar(2000),
  sort_order                integer,
  locale                    varchar(10)
);
CREATE INDEX idx_ext_value_id ON cnet_attributes (ext_value_id);

CREATE TABLE cnet_manufacturers (
  ext_manufacturer_id       varchar(10),
  name                      varchar(255),
  locale                    varchar(10)
);
CREATE INDEX idx_ext_manufacturer_id ON cnet_manufacturers (ext_manufacturer_id);

CREATE TABLE cnet_products (
  ext_product_id            varchar(40),
  ext_category_id           varchar(2),
  ext_manufacturer_id       varchar(10),
  manufacturer_part_number  varchar(40),
  manufacturer_name         varchar(255),
  description               text,
  marketing_text            text,
  status                    varchar(4),
  locale                    varchar(10)
);

