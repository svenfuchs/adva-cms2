create_table "cds_acc_links", :id => false, :force => true do |t|
  t.string "ProdID",  :limit => 40, :null => false
  t.string "PProdID", :limit => 40, :null => false
end

create_table "cds_acc_updates", :id => false, :force => true do |t|
  t.string "ProdID",  :limit => 40, :null => false
end

create_table "cds_acccompat", :id => false, :force => true do |t|
  t.string  "ProdID",       :limit => 40, :null => false
  t.string  "PProductLine", :limit => 10
  t.string  "PModel",       :limit => 10
  t.integer "ComplementID"
  t.string  "PCatID",       :limit => 2,  :null => false
  t.string  "PMfID",        :limit => 10, :null => false
end

add_index "cds_acccompat", ["ComplementID"], :name => "idx_cds_AccCompat2"
add_index "cds_acccompat", ["ProdID"], :name => "idx_cds_AccCompat1"

create_table "cds_acccompat_complement_de", :id => false, :force => true do |t|
  t.string  "ComplementID", :null => false
  t.text "ApplicableCondition"
  t.text "Details"
end

create_table "cds_atr", :id => false, :force => true do |t|
  t.string "ProdID", :limit => 40, :null => false
  t.string "CatID",  :limit => 2,  :null => false
  t.string "AtrID",  :limit => 10, :null => false
  t.string "ValID",  :limit => 10, :null => false
  t.string "UnitID", :limit => 10
  t.float  "NNV"
end

add_index "cds_atr", ["AtrID"], :name => "idx_cds_Atr2"
add_index "cds_atr", ["CatID"], :name => "idx_cds_Atr1"
add_index "cds_atr", ["UnitID"], :name => "idx_cds_Atr4"
add_index "cds_atr", ["ValID"], :name => "idx_cds_Atr3"

create_table "cds_cat", :id => false, :force => true do |t|
  t.string "CatID", :limit => 2,  :null => false
  t.string "AtrID", :limit => 10, :null => false
end

add_index "cds_cat", ["CatID"], :name => "idx_cds_Cat1"

create_table "cds_catalog", :id => false, :force => true do |t|
  t.string "ProdID",     :limit => 40, :null => false
  t.string "StatusCode", :limit => 4,  :null => false
  t.string "Timestamp",  :limit => 10, :null => false
end

add_index "cds_catalog", ["StatusCode"], :name => "idx_cds_Catalog1"

create_table "cds_catalog_info", :id => false, :force => true do |t|
  t.string  "ProdID",           :limit => 40, :null => false
  t.string  "StatusCode",       :limit => 4,  :null => false
  t.string  "LastDeliveryDate", :limit => 10
  t.string  "CreationDate",     :limit => 10
  t.string  "LastRequestDate",  :limit => 10
  t.boolean "IsPartial",                      :null => false
end

add_index "cds_catalog_info", ["StatusCode"], :name => "idx_cds_catalog_info1"

create_table "cds_cctde", :id => false, :force => true do |t|
  t.string "ID",             :limit => 40, :null => false
  t.string "Description",    :limit => 80, :null => false
  t.string "DefaultImageID", :limit => 10
end

create_table "cds_cctee", :id => false, :force => true do |t|
  t.string "ID",             :limit => 40, :null => false
  t.string "Description",    :limit => 80, :null => false
  t.string "DefaultImageID", :limit => 10
end

create_table "cds_digcontent", :id => false, :force => true do |t|
  t.string   "ContentGuid",               :null => false
  t.integer  "MediaTypeID",               :null => false
  t.string   "MimeType",    :limit => 50, :null => false
  t.text     "URL",                       :null => false
  t.datetime "Timestamp"
end

add_index "cds_digcontent", ["MediaTypeID"], :name => "idx_cds_DigContent1"

create_table "cds_digcontent_lang_links", :id => false, :force => true do |t|
  t.string "ContentGuid",  :limit => 36, :null => false
  t.string "LanguageCode", :limit => 20, :null => false
end

add_index "cds_digcontent_lang_links", ["LanguageCode"], :name => "idx_cds_DigContent_Lang_Links1"

create_table "cds_digcontent_langs", :id => false, :force => true do |t|
  t.string "LanguageCode", :limit => 200, :null => false
  t.string "LanguageName", :limit => 200, :null => false
end

create_table "cds_digcontent_links", :id => false, :force => true do |t|
  t.string "ProdID",      :limit => 40, :null => false
  t.string "ContentGuid", :limit => 36, :null => false
end

add_index "cds_digcontent_links", ["ContentGuid"], :name => "idx_cds_DigContent_Links1"

create_table "cds_digcontent_media_types", :id => false, :force => true do |t|
  t.string "MediaTypeID", :null => false
  t.text "MediaTypeDescription", :null => false
end

create_table "cds_digcontent_meta", :id => false, :force => true do |t|
  t.string  "ContentGuid", :limit => 36, :null => false
  t.integer "MetaAtrId",                 :null => false
  t.integer "MetaValueId",               :null => false
end

create_table "cds_digcontent_meta_atr_voc", :id => false, :force => true do |t|
  t.integer "MetaAtrId",                   :null => false
  t.string  "LanguageCode", :limit => 20,  :null => false
  t.string  "MetaAtrName",  :limit => 200, :null => false
end

add_index "cds_digcontent_meta_atr_voc", ["LanguageCode"], :name => "idx_cds_digcontent_meta_atr_voc"

create_table "cds_digcontent_meta_value_voc", :id => false, :force => true do |t|
  t.integer "MetaValueId",                 :null => false
  t.string  "LanguageCode",  :limit => 20, :null => false
  t.text    "MetaValueName",               :null => false
end

add_index "cds_digcontent_meta_value_voc", ["LanguageCode"], :name => "idx_cds_digcontent_meta_value_voc"

create_table "cds_digcontent_prod", :id => false, :force => true do |t|
  t.string "ProdID",     :limit => 40, :null => false
end

create_table "cds_digcontent_region_links", :id => false, :force => true do |t|
  t.string "ContentGuid", :limit => 36, :null => false
  t.string "RegionCode",  :limit => 20, :null => false
end

add_index "cds_digcontent_region_links", ["RegionCode"], :name => "idx_cds_DigContent_Region_Links1"

create_table "cds_digcontent_regions", :id => false, :force => true do |t|
  t.string "RegionCode", :limit => 200, :null => false
  t.string "RegionName", :limit => 200, :null => false
end

create_table "cds_distivoc", :id => false, :force => true do |t|
  t.string "ID",   :limit => 50, :null => false
  t.string "Name", :limit => 50, :null => false
end

create_table "cds_especde", :id => false, :force => true do |t|
  t.string  "ProdID",       :limit => 40, :null => false
  t.string  "SectID",       :limit => 10, :null => false
  t.string  "HdrID",        :limit => 10, :null => false
  t.string  "BodyID",       :limit => 10, :null => false
  t.integer "DisplayOrder",               :null => false
end

add_index "cds_especde", ["BodyID"], :name => "idx_cds_Especde1"
add_index "cds_especde", ["HdrID"], :name => "idx_cds_Especde2"
add_index "cds_especde", ["SectID"], :name => "idx_cds_Especde3"

create_table "cds_especee", :id => false, :force => true do |t|
  t.string  "ProdID",       :limit => 40, :null => false
  t.string  "SectID",       :limit => 10, :null => false
  t.string  "HdrID",        :limit => 10, :null => false
  t.string  "BodyID",       :limit => 10, :null => false
  t.integer "DisplayOrder",               :null => false
end

add_index "cds_especee", ["BodyID"], :name => "idx_cds_especee1"
add_index "cds_especee", ["HdrID"], :name => "idx_cds_especee2"
add_index "cds_especee", ["SectID"], :name => "idx_cds_especee3"

create_table "cds_evocde", :id => false, :force => true do |t|
  t.string "ID", :limit => 40, :null => false
  t.text "Text"
end

create_table "cds_evocee", :id => false, :force => true do |t|
  t.string "ID", :limit => 40, :null => false
  t.text "Text"
end

create_table "cds_metamap", :id => false, :force => true do |t|
  t.string "ProdID",   :limit => 40, :null => false
  t.string "DistiSKU", :limit => 40, :null => false
  t.string "DistiID",  :limit => 10, :null => false
end

add_index "cds_metamap", ["DistiID"], :name => "idx_cds_Metamap1"

create_table "cds_mktde", :id => false, :force => true do |t|
  t.string "MktID", :limit => 40, :null => false
  t.text "Description"
end

create_table "cds_mktee", :id => false, :force => true do |t|
  t.string "MktID", :limit => 40, :null => false
  t.text "Description"
end

create_table "cds_mspecde", :id => false, :force => true do |t|
  t.string  "ProdID",       :limit => 40, :null => false
  t.string  "HdrID",        :limit => 10, :null => false
  t.string  "BodyID",       :limit => 10, :null => false
  t.integer "DisplayOrder",               :null => false
end

add_index "cds_mspecde", ["BodyID"], :name => "idx_cds_Mspecde1"
add_index "cds_mspecde", ["HdrID"], :name => "idx_cds_Mspecde2"

create_table "cds_mspecee", :id => false, :force => true do |t|
  t.string  "ProdID",       :limit => 40, :null => false
  t.string  "HdrID",        :limit => 10, :null => false
  t.string  "BodyID",       :limit => 10, :null => false
  t.integer "DisplayOrder",               :null => false
end

add_index "cds_mspecee", ["BodyID"], :name => "idx_cds_mspecee1"
add_index "cds_mspecee", ["HdrID"], :name => "idx_cds_mspecee2"

create_table "cds_mvocde", :id => false, :force => true do |t|
  t.string  "ID", :limit => 40, :null => false
  t.text "Text"
end

create_table "cds_mvocee", :id => false, :force => true do |t|
  t.string  "ID", :limit => 40, :null => false
  t.text "Text"
end

create_table "cds_prod", :id => false, :force => true do |t|
  t.string "ProdID",     :limit => 40, :null => false
  t.string "CatID",      :limit => 2,  :null => false
  t.string "MktID",      :limit => 10, :null => false
  t.string "ImgID",      :limit => 10, :null => false
  t.string "MfID",       :limit => 10, :null => false
  t.string "MfPN",       :limit => 40, :null => false
  t.string "Reserved1",  :limit => 1
  t.string "Reserved2",  :limit => 1
  t.string "Reserved3",  :limit => 1
  t.string "Reserved4",  :limit => 1
  t.string "Reserved5",  :limit => 1
  t.string "Reserved6",  :limit => 1
  t.string "Reserved7",  :limit => 1
  t.string "Reserved8",  :limit => 1
  t.string "Reserved9",  :limit => 1
  t.string "Reserved10", :limit => 1
  t.string "Reserved11", :limit => 1
  t.string "Reserved12", :limit => 1
  t.string "Reserved13", :limit => 1
  t.string "Reserved14", :limit => 1
end

add_index "cds_prod", ["CatID"], :name => "idx_cds_Prod1"
add_index "cds_prod", ["MfID"], :name => "idx_cds_Prod3"
add_index "cds_prod", ["MktID"], :name => "idx_cds_Prod2"

create_table "cds_skustatus", :id => false, :force => true do |t|
  t.string "StatusCode", :limit => 100, :null => false
  t.string "StatusName", :limit => 100, :null => false
end

create_table "cds_stdnde", :id => false, :force => true do |t|
  t.string "ProdID",    :limit => 40, :null => false
  t.text "Description", :null => false
end

create_table "cds_stdnee", :id => false, :force => true do |t|
  t.string "ProdID",    :limit => 40, :null => false
  t.text "Description", :null => false
end

create_table "cds_unspsc", :id => false, :force => true do |t|
  t.string "ProdID",        :limit => 40, :null => false
  t.string "CommodityCode", :limit => 8,  :null => false
end

add_index "cds_unspsc", ["CommodityCode"], :name => "idx_cds_UNSPSC1"

create_table "cds_unspsc_versioned_commodities", :id => false, :force => true do |t|
  t.string  "CommodityCode",   :limit => 8, :null => false
  t.string  "CommodityName",                :null => false
  t.integer "UNSPSCVersionID",              :null => false
end

create_table "cds_unspsc_versioned_links", :id => false, :force => true do |t|
  t.string  "ProdID",          :limit => 40, :null => false
  t.string  "CommodityCode",   :limit => 8,  :null => false
  t.integer "UNSPSCVersionID",               :null => false
  t.boolean "IsDefault",                     :null => false
end

add_index "cds_unspsc_versioned_links", ["CommodityCode"], :name => "idx_cds_UNSPSC_Versioned_Links2"
add_index "cds_unspsc_versioned_links", ["ProdID"], :name => "idx_cds_UNSPSC_Versioned_Links1"

create_table "cds_unspsc_versions", :id => false, :force => true do |t|
  t.string  "UNSPSCVersionID", :limit => 80, :null => false
  t.string  "UNSPSCVersion",   :limit => 80, :null => false
  t.boolean "IsLatest",                      :null => false
end

create_table "cds_unspsccommodity", :id => false, :force => true do |t|
  t.string "CommodityCode", :limit => 8,  :null => false
  t.string "CommodityName",               :null => false
end

create_table "cds_unspscversion", :id => false, :force => true do |t|
  t.string "UNSPSCVersion", :null => false
end

create_table "cds_vocde", :id => false, :force => true do |t|
  t.string "ID", :null => false
  t.string "Text"
end

create_table "cds_vocee", :id => false, :force => true do |t|
  t.string "ID", :null => false
  t.string "Text"
end
