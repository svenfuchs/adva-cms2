DROP TABLE IF EXISTS "cds_acc_links";
CREATE TABLE "cds_acc_links" (
  "ProdID" varchar(40) NOT NULL,
  "PProdID" varchar(40) NOT NULL,
  PRIMARY KEY ("ProdID","PProdID")
);

DROP TABLE IF EXISTS "cds_acc_updates";
CREATE TABLE "cds_acc_updates" (
  "ProdID" varchar(40) NOT NULL,
  PRIMARY KEY ("ProdID")
);

DROP TABLE IF EXISTS "cds_acccompat";
CREATE TABLE "cds_acccompat" (
  "ProdID" varchar(40) NOT NULL,
  "PProductLine" varchar(10) DEFAULT NULL,
  "PModel" varchar(10) DEFAULT NULL,
  "ComplementID" int(11) DEFAULT NULL,
  "PCatID" char(2) NOT NULL,
  "PMfID" varchar(10) NOT NULL
);
CREATE INDEX "idx_cds_AccCompat1" ON cds_acccompat ("ProdID");
CREATE INDEX "idx_cds_AccCompat2" ON cds_acccompat ("ComplementID");

DROP TABLE IF EXISTS "cds_acccompat_complement_de";
CREATE TABLE "cds_acccompat_complement_de" (
  "ComplementID" int(11) NOT NULL,
  "ApplicableCondition" text,
  "Details" text,
  PRIMARY KEY ("ComplementID")
);

DROP TABLE IF EXISTS "cds_atr";
CREATE TABLE "cds_atr" (
  "ProdID" varchar(40) NOT NULL,
  "CatID" char(2) NOT NULL,
  "AtrID" varchar(10) NOT NULL,
  "ValID" varchar(10) NOT NULL,
  "UnitID" varchar(10) DEFAULT NULL,
  "NNV" double DEFAULT NULL,
  PRIMARY KEY ("ProdID","AtrID","ValID")
);
CREATE INDEX "idx_cds_Atr1" ON cds_atr ("CatID");
CREATE INDEX "idx_cds_Atr2" ON cds_atr ("AtrID");
CREATE INDEX "idx_cds_Atr3" ON cds_atr ("ValID");
CREATE INDEX "idx_cds_Atr4" ON cds_atr ("UnitID");

DROP TABLE IF EXISTS "cds_cat";
CREATE TABLE "cds_cat" (
  "CatID" char(2) NOT NULL,
  "AtrID" varchar(10) NOT NULL,
  PRIMARY KEY ("AtrID","CatID")
);
CREATE INDEX "idx_cds_Cat1" ON cds_cat ("CatID");

DROP TABLE IF EXISTS "cds_catalog";
CREATE TABLE "cds_catalog" (
  "ProdID" varchar(40) NOT NULL,
  "StatusCode" varchar(4) NOT NULL,
  "Timestamp" varchar(10) NOT NULL,
  PRIMARY KEY ("ProdID")
);
CREATE INDEX "idx_cds_Catalog1" ON cds_catalog ("StatusCode");

DROP TABLE IF EXISTS "cds_catalog_info";
CREATE TABLE "cds_catalog_info" (
  "ProdID" varchar(40) NOT NULL,
  "StatusCode" varchar(4) NOT NULL,
  "LastDeliveryDate" varchar(10) NULL,
  "CreationDate" varchar(10) NULL,
  "LastRequestDate" varchar(10) NULL,
  "IsPartial" TINYINT(1) NOT NULL,
  PRIMARY KEY ("ProdID")
);
CREATE INDEX "idx_cds_catalog_info1" ON cds_catalog_info ("StatusCode");

DROP TABLE IF EXISTS "cds_cctde";
CREATE TABLE "cds_cctde" (
  "ID" char(2) NOT NULL,
  "Description" varchar(80) NOT NULL,
  "DefaultImageID" varchar(10) DEFAULT NULL,
  PRIMARY KEY ("ID")
);

DROP TABLE IF EXISTS "cds_cctee";
CREATE TABLE "cds_cctee" (
  "ID" char(2) NOT NULL,
  "Description" varchar(80) NOT NULL,
  "DefaultImageID" varchar(10) DEFAULT NULL,
  PRIMARY KEY ("ID")
);

DROP TABLE IF EXISTS "cds_digcontent";
CREATE TABLE "cds_digcontent" (
  "ContentGuid" char(36) NOT NULL,
  "MediaTypeID" int(11) NOT NULL,
  "MimeType" varchar(50) NOT NULL,
  "URL" text NOT NULL,
  "Timestamp" datetime DEFAULT NULL,
  PRIMARY KEY ("ContentGuid")
);
CREATE INDEX "idx_cds_DigContent1" ON cds_digcontent ("MediaTypeID");

DROP TABLE IF EXISTS "cds_digcontent_meta";
CREATE TABLE "cds_digcontent_meta" (
  "ContentGuid" char(36) NOT NULL,
  "MetaAtrId" int(11) NOT NULL,
  "MetaValueId" int(11) NOT NULL,
  PRIMARY KEY ("ContentGuid", "MetaAtrId", "MetaValueId")
);
DROP TABLE IF EXISTS "cds_digcontent_meta_atr_voc";
CREATE TABLE "cds_digcontent_meta_atr_voc" (
  "MetaAtrId" int(11) NOT NULL,
  "LanguageCode" varchar(20) NOT NULL,
  "MetaAtrName" varchar(200) NOT NULL,
  PRIMARY KEY ("MetaAtrId", "LanguageCode")
);
CREATE INDEX "idx_cds_digcontent_meta_atr_voc1" ON cds_digcontent_meta_atr_voc ("LanguageCode");

DROP TABLE IF EXISTS "cds_digcontent_meta_value_voc";
CREATE TABLE "cds_digcontent_meta_value_voc" (
  "MetaValueId" int(11) NOT NULL,
  "LanguageCode" varchar(20) NOT NULL,
  "MetaValueName" text NOT NULL,
  PRIMARY KEY ("MetaValueId", "LanguageCode")
);
CREATE INDEX "idx_cds_digcontent_meta_value_voc" ON cds_digcontent_meta_value_voc ("LanguageCode");

DROP TABLE IF EXISTS "cds_digcontent_lang_links";
CREATE TABLE "cds_digcontent_lang_links" (
  "ContentGuid" char(36) NOT NULL,
  "LanguageCode" varchar(20) NOT NULL,
  PRIMARY KEY ("ContentGuid","LanguageCode")
);
CREATE INDEX "idx_cds_DigContent_Lang_Links1" ON cds_digcontent_lang_links ("LanguageCode");

DROP TABLE IF EXISTS "cds_digcontent_langs";
CREATE TABLE "cds_digcontent_langs" (
  "LanguageCode" varchar(20) NOT NULL,
  "LanguageName" varchar(200) NOT NULL,
  PRIMARY KEY ("LanguageCode")
);

DROP TABLE IF EXISTS "cds_digcontent_links";
CREATE TABLE "cds_digcontent_links" (
  "ProdID" varchar(40) NOT NULL,
  "ContentGuid" char(36) NOT NULL,
  PRIMARY KEY ("ProdID","ContentGuid")
);
CREATE INDEX "idx_cds_DigContent_Links1" ON cds_digcontent_links ("ContentGuid");

DROP TABLE IF EXISTS "cds_digcontent_media_types";
CREATE TABLE "cds_digcontent_media_types" (
  "MediaTypeID" int(11) NOT NULL,
  "MediaTypeDescription" text NOT NULL,
  PRIMARY KEY ("MediaTypeID")
);

DROP TABLE IF EXISTS "cds_digcontent_prod";
CREATE TABLE "cds_digcontent_prod" (
  "ProdID" varchar(40) NOT NULL,
  PRIMARY KEY ("ProdID")
);

DROP TABLE IF EXISTS "cds_digcontent_region_links";
CREATE TABLE "cds_digcontent_region_links" (
  "ContentGuid" char(36) NOT NULL,
  "RegionCode" varchar(20) NOT NULL,
  PRIMARY KEY ("ContentGuid","RegionCode")
);
CREATE INDEX "idx_cds_DigContent_Region_Links1" ON cds_digcontent_region_links ("RegionCode");

DROP TABLE IF EXISTS "cds_digcontent_regions";
CREATE TABLE "cds_digcontent_regions" (
  "RegionCode" varchar(20) NOT NULL,
  "RegionName" varchar(200) NOT NULL,
  PRIMARY KEY ("RegionCode")
);

DROP TABLE IF EXISTS "cds_distivoc";
CREATE TABLE "cds_distivoc" (
  "ID" varchar(10) NOT NULL,
  "Name" varchar(50) NOT NULL,
  PRIMARY KEY ("ID")
);

DROP TABLE IF EXISTS "cds_especde";
CREATE TABLE "cds_especde" (
  "ProdID" varchar(40) NOT NULL,
  "SectID" varchar(10) NOT NULL,
  "HdrID" varchar(10) NOT NULL,
  "BodyID" varchar(10) NOT NULL,
  "DisplayOrder" int(11) NOT NULL,
  PRIMARY KEY ("ProdID","SectID","BodyID","HdrID")
);
CREATE INDEX "idx_cds_Especde1" ON cds_especde ("BodyID");
CREATE INDEX "idx_cds_Especde2" ON cds_especde ("HdrID");
CREATE INDEX "idx_cds_Especde3" ON cds_especde ("SectID");

DROP TABLE IF EXISTS "cds_especee";
CREATE TABLE "cds_especee" (
  "ProdID" varchar(40) NOT NULL,
  "SectID" varchar(10) NOT NULL,
  "HdrID" varchar(10) NOT NULL,
  "BodyID" varchar(10) NOT NULL,
  "DisplayOrder" int(11) NOT NULL,
  PRIMARY KEY ("ProdID","SectID","BodyID","HdrID")
);
CREATE INDEX "idx_cds_Especee1" ON cds_especee ("BodyID");
CREATE INDEX "idx_cds_Especee2" ON cds_especee ("HdrID");
CREATE INDEX "idx_cds_Especee3" ON cds_especee ("SectID");

DROP TABLE IF EXISTS "cds_evocde";
CREATE TABLE "cds_evocde" (
  "ID" varchar(10) NOT NULL,
  "Text" text,
  PRIMARY KEY ("ID")
);

DROP TABLE IF EXISTS "cds_evocee";
CREATE TABLE "cds_evocee" (
  "ID" varchar(10) NOT NULL,
  "Text" text,
  PRIMARY KEY ("ID")
);

DROP TABLE IF EXISTS "cds_metamap";
CREATE TABLE "cds_metamap" (
  "ProdID" varchar(40) NOT NULL,
  "DistiSKU" varchar(40) NOT NULL,
  "DistiID" varchar(10) NOT NULL,
  PRIMARY KEY ("ProdID","DistiID","DistiSKU")
);
CREATE INDEX "idx_cds_Metamap1" ON cds_metamap ("DistiID");

DROP TABLE IF EXISTS "cds_mktde";
CREATE TABLE "cds_mktde" (
  "MktID" varchar(10) NOT NULL,
  "Description" text,
  PRIMARY KEY ("MktID")
);

DROP TABLE IF EXISTS "cds_mktee";
CREATE TABLE "cds_mktee" (
  "MktID" varchar(10) NOT NULL,
  "Description" text,
  PRIMARY KEY ("MktID")
);

DROP TABLE IF EXISTS "cds_mspecde";
CREATE TABLE "cds_mspecde" (
  "ProdID" varchar(40) NOT NULL,
  "HdrID" varchar(10) NOT NULL,
  "BodyID" varchar(10) NOT NULL,
  "DisplayOrder" int(11) NOT NULL,
  PRIMARY KEY ("ProdID","HdrID","BodyID")
);
CREATE INDEX "idx_cds_Mspecde1" ON cds_mspecde ("BodyID");
CREATE INDEX "idx_cds_Mspecde2" ON cds_mspecde ("HdrID");

DROP TABLE IF EXISTS "cds_mspecee";
CREATE TABLE "cds_mspecee" (
  "ProdID" varchar(40) NOT NULL,
  "HdrID" varchar(10) NOT NULL,
  "BodyID" varchar(10) NOT NULL,
  "DisplayOrder" int(11) NOT NULL,
  PRIMARY KEY ("ProdID","HdrID","BodyID")
);
CREATE INDEX "idx_cds_Mspecee1" ON cds_mspecee ("BodyID");
CREATE INDEX "idx_cds_Mspecee2" ON cds_mspecee ("HdrID");

DROP TABLE IF EXISTS "cds_mvocde";
CREATE TABLE "cds_mvocde" (
  "ID" varchar(10) NOT NULL,
  "Text" text,
  PRIMARY KEY ("ID")
);

DROP TABLE IF EXISTS "cds_mvocee";
CREATE TABLE "cds_mvocee" (
  "ID" varchar(10) NOT NULL,
  "Text" text,
  PRIMARY KEY ("ID")
);

DROP TABLE IF EXISTS "cds_prod";
CREATE TABLE "cds_prod" (
  "ProdID" varchar(40) NOT NULL,
  "CatID" char(2) NOT NULL,
  "MktID" varchar(10) NOT NULL,
  "ImgID" varchar(10) NOT NULL,
  "MfID" varchar(10) NOT NULL,
  "MfPN" varchar(40) NOT NULL,
  "Reserved1" varchar(1) DEFAULT NULL,
  "Reserved2" varchar(1) DEFAULT NULL,
  "Reserved3" varchar(1) DEFAULT NULL,
  "Reserved4" varchar(1) DEFAULT NULL,
  "Reserved5" varchar(1) DEFAULT NULL,
  "Reserved6" varchar(1) DEFAULT NULL,
  "Reserved7" varchar(1) DEFAULT NULL,
  "Reserved8" varchar(1) DEFAULT NULL,
  "Reserved9" varchar(1) DEFAULT NULL,
  "Reserved10" varchar(1) DEFAULT NULL,
  "Reserved11" varchar(1) DEFAULT NULL,
  "Reserved12" varchar(1) DEFAULT NULL,
  "Reserved13" varchar(1) DEFAULT NULL,
  "Reserved14" varchar(1) DEFAULT NULL,
  PRIMARY KEY ("ProdID")
);
CREATE INDEX "idx_cds_Prod1" ON cds_prod ("CatID");
CREATE INDEX "idx_cds_Prod2" ON cds_prod ("MktID");
CREATE INDEX "idx_cds_Prod3" ON cds_prod ("MfID");

DROP TABLE IF EXISTS "cds_skustatus";
CREATE TABLE "cds_skustatus" (
  "StatusCode" varchar(4) NOT NULL,
  "StatusName" varchar(100) NOT NULL,
  PRIMARY KEY ("StatusCode")
);

DROP TABLE IF EXISTS "cds_stdnde";
CREATE TABLE "cds_stdnde" (
  "ProdID" varchar(40) NOT NULL,
  "Description" text NOT NULL,
  PRIMARY KEY ("ProdID")
);

DROP TABLE IF EXISTS "cds_stdnee";
CREATE TABLE "cds_stdnee" (
  "ProdID" varchar(40) NOT NULL,
  "Description" text NOT NULL,
  PRIMARY KEY ("ProdID")
);

DROP TABLE IF EXISTS "cds_unspsc";
CREATE TABLE "cds_unspsc" (
  "ProdID" varchar(40) NOT NULL,
  "CommodityCode" varchar(8) NOT NULL,
  PRIMARY KEY ("ProdID","CommodityCode")
);
CREATE INDEX "idx_cds_UNSPSC1" ON cds_unspsc ("CommodityCode");

DROP TABLE IF EXISTS "cds_unspsc_versioned_commodities";
CREATE TABLE "cds_unspsc_versioned_commodities" (
  "CommodityCode" varchar(8) NOT NULL,
  "CommodityName" varchar(255) NOT NULL,
  "UNSPSCVersionID" int(11) NOT NULL,
  PRIMARY KEY ("UNSPSCVersionID","CommodityCode")
);

DROP TABLE IF EXISTS "cds_unspsc_versioned_links";
CREATE TABLE "cds_unspsc_versioned_links" (
  "ProdID" varchar(40) NOT NULL,
  "CommodityCode" varchar(8) NOT NULL,
  "UNSPSCVersionID" int(11) NOT NULL,
  "IsDefault" tinyint(1) NOT NULL,
  PRIMARY KEY ("UNSPSCVersionID","ProdID","CommodityCode")
);
CREATE INDEX "idx_cds_UNSPSC_Versioned_Links1" ON cds_unspsc_versioned_links ("ProdID");
CREATE INDEX "idx_cds_UNSPSC_Versioned_Links2" ON cds_unspsc_versioned_links ("CommodityCode");

DROP TABLE IF EXISTS "cds_unspsc_versions";
CREATE TABLE "cds_unspsc_versions" (
  "UNSPSCVersionID" int(11) NOT NULL,
  "UNSPSCVersion" varchar(80) NOT NULL,
  "IsLatest" tinyint(1) NOT NULL,
  PRIMARY KEY ("UNSPSCVersionID")
);

DROP TABLE IF EXISTS "cds_unspsccommodity";
CREATE TABLE "cds_unspsccommodity" (
  "CommodityCode" varchar(8) NOT NULL,
  "CommodityName" varchar(255) NOT NULL,
  PRIMARY KEY ("CommodityCode")
);

DROP TABLE IF EXISTS "cds_unspscversion";
CREATE TABLE "cds_unspscversion" (
  "UNSPSCVersion" varchar(10) NOT NULL,
  PRIMARY KEY ("UNSPSCVersion")
);

DROP TABLE IF EXISTS "cds_vocde";
CREATE TABLE "cds_vocde" (
  "ID" varchar(10) NOT NULL,
  "Text" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("ID")
);

DROP TABLE IF EXISTS "cds_vocee";
CREATE TABLE "cds_vocee" (
  "ID" varchar(10) NOT NULL,
  "Text" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("ID")
);
