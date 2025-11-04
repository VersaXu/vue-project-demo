CREATE TABLE CDM.dim_prod_dmns
(
    prod_srrg_key varchar(50) NOT NULL,
    prod_cd varchar(50),
    prod_lvl varchar(50),
    uppr_prod_srrg_key varchar(50),
	prod_wind_cd varchar(50),
	shr_crrn_cd varchar(50),
    shr_crrn varchar(50),
	vltn_crrn_cd_205385 varchar(50),
    vltn_crrn_205385 varchar(50),
	prod_typ_cd_203427 varchar(50),
    prod_typ_203427 varchar(50),
	prod_stt_cd_200282 varchar(50),
	prod_chn_fll_nm_60001 varchar(500),
    prod_chn_abbr_intr_use_200136 varchar(500),
	prod_chns_abbr_rglt_rprt_60011 varchar(500),
    CONSTRAINT C_PRIMARY PRIMARY KEY (prod_srrg_key) ENABLED
);

COMMENT ON TABLE CDM.dim_prod_dmns IS '产品维度表';


CREATE PROJECTION CDM.dim_prod_dmns_b0 /*+basename(dim_prod_dmns)*/ 
(
prod_srrg_key,
prod_cd,
prod_lvl,
uppr_prod_srrg_key,
prod_wind_cd,
shr_crrn_cd,
shr_crrn,
vltn_crrn_cd_205385,
vltn_crrn_205385,
prod_typ_cd_203427,
prod_typ_203427,
prod_stt_cd_200282,
prod_chn_fll_nm_60001,
prod_chn_abbr_intr_use_200136,
prod_chns_abbr_rglt_rprt_60011
)
AS
 SELECT dim_prod_dmns.prod_srrg_key,
		dim_prod_dmns.prod_cd,
		dim_prod_dmns.prod_lvl,
		dim_prod_dmns.uppr_prod_srrg_key,
		dim_prod_dmns.prod_wind_cd,
		dim_prod_dmns.shr_crrn_cd,
		dim_prod_dmns.shr_crrn,
		dim_prod_dmns.vltn_crrn_cd_205385,
		dim_prod_dmns.vltn_crrn_205385,
		dim_prod_dmns.prod_typ_cd_203427,
		dim_prod_dmns.prod_typ_203427,
		dim_prod_dmns.prod_stt_cd_200282,
		dim_prod_dmns.prod_chn_fll_nm_60001,
		dim_prod_dmns.prod_chn_abbr_intr_use_200136,
		dim_prod_dmns.prod_chns_abbr_rglt_rprt_60011
 FROM CDM.dim_prod_dmns
 ORDER BY dim_prod_dmns.prod_srrg_key
SEGMENTED BY hash(dim_prod_dmns.prod_srrg_key) ALL NODES;

COMMENT ON PROJECTION CDM.dim_prod_dmns_b0 IS '产品维度表';

COMMENT ON COLUMN CDM.dim_prod_dmns_b0."prod_srrg_key" IS '产品代理键（产品代码+产品层级）';

COMMENT ON COLUMN CDM.dim_prod_dmns_b0."prod_cd" IS '产品代码';

COMMENT ON COLUMN CDM.dim_prod_dmns_b0."prod_lvl" IS '产品层级';

COMMENT ON COLUMN CDM.dim_prod_dmns_b0."uppr_prod_srrg_key" IS '上级产品代理键';

COMMENT ON COLUMN CDM.dim_prod_dmns_b0."prod_wind_cd" IS '产品Wind代码';

COMMENT ON COLUMN CDM.dim_prod_dmns_b0."shr_crrn_cd" IS '份额币种代码';

COMMENT ON COLUMN CDM.dim_prod_dmns_b0."shr_crrn" IS '份额币种';

COMMENT ON COLUMN CDM.dim_prod_dmns_b0."vltn_crrn_cd_205385" IS '估值币种代码';

COMMENT ON COLUMN CDM.dim_prod_dmns_b0."vltn_crrn_205385" IS '估值币种';

COMMENT ON COLUMN CDM.dim_prod_dmns_b0."prod_typ_cd_203427" IS '产品类型代码_203427';

COMMENT ON COLUMN CDM.dim_prod_dmns_b0."prod_typ_203427" IS '产品类型_203427';

COMMENT ON COLUMN CDM.dim_prod_dmns_b0."prod_stt_cd_200282" IS '产品状态代码_200282';

COMMENT ON COLUMN CDM.dim_prod_dmns_b0."prod_chn_fll_nm_60001" IS '产品中文全称_60001';

COMMENT ON COLUMN CDM.dim_prod_dmns_b0."prod_chn_abbr_intr_use_200136" IS '产品中文简称（内部使用）_200136';

COMMENT ON COLUMN CDM.dim_prod_dmns_b0."prod_chns_abbr_rglt_rprt_60011" IS '产品中文简称（监管报送）_60011';


SELECT MARK_DESIGN_KSAFE(1);

CREATE TABLE CDM.dws_inv_prod_indx_n1
(
    prod_srrg_key varchar(500) NOT NULL,
    dt date NOT NULL,
    prod_cd varchar(50),
    prod_lvl varchar(50),
    prod_wind_cd varchar(50),
    indx_id varchar(500) NOT NULL,
    indx_nm varchar(500),
    indx_vl numeric(37,16),
    CONSTRAINT C_PRIMARY PRIMARY KEY (prod_srrg_key, dt, indx_id) ENABLED
);

COMMENT ON TABLE CDM.dws_inv_prod_indx_n1 IS '产品指标表_N1';


CREATE PROJECTION CDM.dws_inv_prod_indx_n1_b0 /*+basename(dws_inv_prod_indx_n1)*/ 
(
 prod_srrg_key,
 dt,
 prod_cd,
 prod_lvl,
 prod_wind_cd,
 indx_id,
 indx_nm,
 indx_vl
)
AS
 SELECT dws_inv_prod_indx_n1.prod_srrg_key,
        dws_inv_prod_indx_n1.dt,
        dws_inv_prod_indx_n1.prod_cd,
        dws_inv_prod_indx_n1.prod_lvl,
        dws_inv_prod_indx_n1.prod_wind_cd,
        dws_inv_prod_indx_n1.indx_id,
        dws_inv_prod_indx_n1.indx_nm,
        dws_inv_prod_indx_n1.indx_vl
 FROM CDM.dws_inv_prod_indx_n1
 ORDER BY dws_inv_prod_indx_n1.prod_srrg_key,
          dws_inv_prod_indx_n1.dt,
          dws_inv_prod_indx_n1.indx_id
SEGMENTED BY hash(dws_inv_prod_indx_n1.prod_srrg_key, dws_inv_prod_indx_n1.dt, dws_inv_prod_indx_n1.indx_id) ALL NODES;

COMMENT ON PROJECTION CDM.dws_inv_prod_indx_n1_b0 IS '产品指标表_N1';

COMMENT ON COLUMN CDM.dws_inv_prod_indx_n1_b0."prod_srrg_key" IS '产品代理键（产品代码+产品层级）';

COMMENT ON COLUMN CDM.dws_inv_prod_indx_n1_b0."dt" IS '日期';

COMMENT ON COLUMN CDM.dws_inv_prod_indx_n1_b0."prod_cd" IS '产品代码';

COMMENT ON COLUMN CDM.dws_inv_prod_indx_n1_b0."prod_lvl" IS '产品层级';

COMMENT ON COLUMN CDM.dws_inv_prod_indx_n1_b0."prod_wind_cd" IS '产品Wind代码';

COMMENT ON COLUMN CDM.dws_inv_prod_indx_n1_b0."indx_id" IS '指标ID';

COMMENT ON COLUMN CDM.dws_inv_prod_indx_n1_b0."indx_nm" IS '指标名称';

COMMENT ON COLUMN CDM.dws_inv_prod_indx_n1_b0."indx_vl" IS '指标值';


SELECT MARK_DESIGN_KSAFE(1);

CREATE TABLE CDM.dws_mkt_all_chnn_hld_indx
(
    clnd_dt date NOT NULL,
    prod_srrg_key varchar(500),
	cstm_srrg_key varchar(500),
	shr_crrn varchar(500),
	shr_blnc numeric(37,8),
	prod_nm varchar(500),
	prod_cd varchar(50),
	mn_prod_nm varchar(500),
	prod_typ_203427 varchar(500),
	mn_prod_cd varchar(500)
)
PARTITION BY (dws_mkt_all_chnn_hld_indx.clnd_dt) GROUP BY (CASE WHEN ("datediff"('year', dws_mkt_all_chnn_hld_indx.clnd_dt, ((now())::timestamptz)::date) >= 2) THEN (date_trunc('year', dws_mkt_all_chnn_hld_indx.clnd_dt))::date WHEN ("datediff"('month', dws_mkt_all_chnn_hld_indx.clnd_dt, ((now())::timestamptz)::date) >= 2) THEN (date_trunc('month', dws_mkt_all_chnn_hld_indx.clnd_dt))::date ELSE dws_mkt_all_chnn_hld_indx.clnd_dt END);

COMMENT ON TABLE CDM.dws_mkt_all_chnn_hld_indx IS '全渠道保有指标表';

CREATE PROJECTION CDM.dws_mkt_all_chnn_hld_indx_b0 /*+basename(dws_mkt_all_chnn_hld_indx)*/ 
(
 clnd_dt,
 prod_srrg_key,
 cstm_srrg_key,
 prod_cd,
 prod_nm,
 mn_prod_cd,
 mn_prod_nm,
 prod_typ_203427,
 shr_crrn,
 shr_blnc
)
AS
 SELECT dws_mkt_all_chnn_hld_indx.clnd_dt,
        dws_mkt_all_chnn_hld_indx.prod_srrg_key,
        dws_mkt_all_chnn_hld_indx.cstm_srrg_key,
        dws_mkt_all_chnn_hld_indx.prod_cd,
        dws_mkt_all_chnn_hld_indx.prod_nm,
        dws_mkt_all_chnn_hld_indx.mn_prod_cd,
        dws_mkt_all_chnn_hld_indx.mn_prod_nm,
        dws_mkt_all_chnn_hld_indx.prod_typ_203427,
        dws_mkt_all_chnn_hld_indx.shr_crrn,
        dws_mkt_all_chnn_hld_indx.shr_blnc
 FROM CDM.dws_mkt_all_chnn_hld_indx
 ORDER BY dws_mkt_all_chnn_hld_indx.cstm_srrg_key,
          dws_mkt_all_chnn_hld_indx.prod_srrg_key,
          dws_mkt_all_chnn_hld_indx.clnd_dt
SEGMENTED BY hash(dws_mkt_all_chnn_hld_indx.prod_srrg_key) ALL NODES;

COMMENT ON PROJECTION CDM.dws_mkt_all_chnn_hld_indx_b0 IS '全渠道保有指标表';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_hld_indx_b0."clnd_dt" IS '自然日期';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_hld_indx_b0."prod_srrg_key" IS '产品代理键';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_hld_indx_b0."cstm_srrg_key" IS '客户代理键（客户号）';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_hld_indx_b0."prod_cd" IS '产品代码';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_hld_indx_b0."prod_nm" IS '产品名称';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_hld_indx_b0."mn_prod_nm" IS '主产品名称';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_hld_indx_b0."mn_prod_cd" IS '主产品代码';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_hld_indx_b0."prod_typ_203427" IS '产品类型_203427';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_hld_indx_b0."shr_crrn" IS '份额币种';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_hld_indx_b0."shr_blnc" IS '份额余额';

SELECT MARK_DESIGN_KSAFE(1);

// 全渠道交易指标表
CREATE TABLE CDM.dws_mkt_all_chnn_trd_indx
(
    prod_srrg_key varchar(500),
	orgn_crrn_cnfr_amnt numeric(37,8),
    fnct_crrn_cnfr_amnt numeric(37,8),
	fnd_bsns_trd_drct_cd varchar(10),
	mn_prod_cd varchar(500),
    mn_prod_nm varchar(500),
	fnd_bsns_typ varchar(500),
	orgn_crrn_trd_fee_blng_fnd_asst numeric(37,8),
	fnct_crrn_strk_prc numeric(37,8),
	shr_crrn varchar(500),
	appl_dt date,
	prod_nm varchar(500),
	fnd_bsns_typ_cd varchar(50),
	if_spns_fnd_203301 varchar(500),
	fnct_crrn_appl_amnt numeric(37,8),
	orgn_crrn_strk_prc numeric(37,8),
	orgn_crrn_dscn_bfr_trd_fee numeric(37,8),
	orgn_crrn_trd_fee numeric(37,8),
	prod_typ_203427 varchar(500),
	orgn_crrn_appl_amnt numeric(37,8),
	appl_shr numeric(37,8),
	orgn_crrn_ttl_cst numeric(37,8),
	cnfr_rslt_cd varchar(500),
	orgn_crrn_trd_fee_blng_sllr numeric(37,8),
	ta_ex_bsns_flg varchar(50),
	cnfr_dt date NOT NULL,
	cnfr_shr numeric(37,8),
	ta_bsns_flg varchar(50),
	prod_cd varchar(500),
)
PARTITION BY (dws_mkt_all_chnn_trd_indx.cnfr_dt) GROUP BY (CASE WHEN ("datediff"('year', dws_mkt_all_chnn_trd_indx.cnfr_dt, ((now())::timestamptz)::date) >= 2) THEN (date_trunc('year', dws_mkt_all_chnn_trd_indx.cnfr_dt))::date WHEN ("datediff"('month', dws_mkt_all_chnn_trd_indx.cnfr_dt, ((now())::timestamptz)::date) >= 2) THEN (date_trunc('month', dws_mkt_all_chnn_trd_indx.cnfr_dt))::date ELSE dws_mkt_all_chnn_trd_indx.cnfr_dt END);

COMMENT ON TABLE CDM.dws_mkt_all_chnn_trd_indx IS '全渠道交易指标表';

CREATE PROJECTION CDM.dws_mkt_all_chnn_trd_indx_b0 /*+basename(dws_mkt_all_chnn_trd_indx)*/ 
(
cnfr_dt,
appl_dt,
prod_srrg_key,
cstm_srrg_key,
prod_cd,
prod_nm,
mn_prod_cd,
mn_prod_nm,
prod_typ_203427,
shr_crrn,
if_spns_fnd_203301,
fnd_bsns_typ_cd,
fnd_bsns_typ,
ta_bsns_flg,
ta_ex_bsns_flg,
cnfr_rslt_cd,
orgn_crrn_strk_prc,
fnct_crrn_strk_prc,
orgn_crrn_cnfr_amnt,
fnct_crrn_cnfr_amnt,
cnfr_shr,
orgn_crrn_appl_amnt,
fnct_crrn_appl_amnt,
appl_shr,
orgn_crrn_trd_fee,
orgn_crrn_trd_fee_blng_sllr,
orgn_crrn_trd_fee_blng_fnd_asst,
orgn_crrn_dscn_bfr_trd_fee,
orgn_crrn_ttl_cst
)
AS
 SELECT dws_mkt_all_chnn_trd_indx.cnfr_dt,
		dws_mkt_all_chnn_trd_indx.appl_dt,
		dws_mkt_all_chnn_trd_indx.prod_srrg_key,
		dws_mkt_all_chnn_trd_indx.cstm_srrg_key,
		dws_mkt_all_chnn_trd_indx.prod_cd,
		dws_mkt_all_chnn_trd_indx.prod_nm,
		dws_mkt_all_chnn_trd_indx.mn_prod_cd,
		dws_mkt_all_chnn_trd_indx.mn_prod_nm,
		dws_mkt_all_chnn_trd_indx.prod_typ_203427,
		dws_mkt_all_chnn_trd_indx.shr_crrn,
		dws_mkt_all_chnn_trd_indx.if_spns_fnd_203301,
		dws_mkt_all_chnn_trd_indx.fnd_bsns_typ_cd,
		dws_mkt_all_chnn_trd_indx.fnd_bsns_typ,
		dws_mkt_all_chnn_trd_indx.ta_bsns_flg,
		dws_mkt_all_chnn_trd_indx.ta_ex_bsns_flg,
		dws_mkt_all_chnn_trd_indx.cnfr_rslt_cd,
		dws_mkt_all_chnn_trd_indx.orgn_crrn_strk_prc,
		dws_mkt_all_chnn_trd_indx.fnct_crrn_strk_prc,
		dws_mkt_all_chnn_trd_indx.orgn_crrn_cnfr_amnt,
		dws_mkt_all_chnn_trd_indx.fnct_crrn_cnfr_amnt,
		dws_mkt_all_chnn_trd_indx.cnfr_shr,
		dws_mkt_all_chnn_trd_indx.orgn_crrn_appl_amnt,
		dws_mkt_all_chnn_trd_indx.fnct_crrn_appl_amnt,
		dws_mkt_all_chnn_trd_indx.appl_shr,
		dws_mkt_all_chnn_trd_indx.orgn_crrn_trd_fee,
		dws_mkt_all_chnn_trd_indx.orgn_crrn_trd_fee_blng_sllr,
		dws_mkt_all_chnn_trd_indx.orgn_crrn_trd_fee_blng_fnd_asst,
		dws_mkt_all_chnn_trd_indx.orgn_crrn_dscn_bfr_trd_fee,
		dws_mkt_all_chnn_trd_indx.orgn_crrn_ttl_cst
 FROM CDM.dws_mkt_all_chnn_trd_indx
 ORDER BY dws_mkt_all_chnn_trd_indx.cstm_srrg_key,
          dws_mkt_all_chnn_trd_indx.prod_srrg_key,
          dws_mkt_all_chnn_trd_indx.cnfr_dt
SEGMENTED BY hash(dws_mkt_all_chnn_trd_indx.prod_srrg_key) ALL NODES;

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.cnfr_dt IS '确认日期';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.appl_dt IS '申请日期';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.prod_srrg_key IS '产品代理键';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.cstm_srrg_key IS '客户代理键（客户号）';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.prod_cd IS '产品代码';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.prod_nm IS '产品名称';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.mn_prod_cd IS '主产品代码';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.mn_prod_nm IS '主产品名称';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.prod_typ_203427 IS '产品类型_203427';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.shr_crrn IS '份额币种';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.if_spns_fnd_203301 IS '产品是否发起式';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.fnd_bsns_typ_cd IS '基金业务类型代码';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.fnd_bsns_typ IS '基金业务类型';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.ta_bsns_flg IS 'TA业务标志';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.ta_ex_bsns_flg IS 'TA外部业务标志';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.cnfr_rslt_cd IS '确认结果代码';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.orgn_crrn_strk_prc IS '成交价格（原币）';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.fnct_crrn_strk_prc IS '成交价格（本币）';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.orgn_crrn_cnfr_amnt IS '确认金额（原币）';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.fnct_crrn_cnfr_amnt IS '确认金额（本币）';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.cnfr_shr IS '确认份额';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.orgn_crrn_appl_amnt IS '申请金额（原币）';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.fnct_crrn_appl_amnt IS '申请金额（本币）';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.appl_shr IS '申请份额';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.orgn_crrn_trd_fee IS '交易费（原币）';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.orgn_crrn_trd_fee_blng_sllr IS '交易费归销售机构（原币）';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.orgn_crrn_trd_fee_blng_fnd_asst IS '交易费归基金资产（原币）';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.orgn_crrn_dscn_bfr_trd_fee IS '打折前交易费（原币）';

COMMENT ON COLUMN CDM.dws_mkt_all_chnn_trd_indx.orgn_crrn_ttl_cst IS '总费用（原币）';


SELECT MARK_DESIGN_KSAFE(1);

CREATE TABLE DL_ODS_INFO.s034_wfdb_asharedescription
(
    object_id varchar(200) NOT NULL,
    s_info_windcode varchar(100),
    s_info_code varchar(100),
    s_info_name varchar(100),
    s_info_compname varchar(200),
    s_info_compnameeng varchar(200),
    s_info_isincode varchar(100),
    s_info_exchmarket varchar(100),
    s_info_listboard varchar(100),
    s_info_listdate varchar(100),
    s_info_delistdate varchar(100),
    s_info_sedolcode varchar(100),
    crncy_code varchar(100),
    s_info_pinyin varchar(100),
    s_info_listboardname varchar(100),
    is_shsc numeric(5,0),
    s_info_compcode varchar(200),
    opdate date,
    opmode varchar(100),
    clientopdate date,
    clientadddate date,
    mopdate date,
    etl_btch_dt date,
    etl_src_tbl_nm varchar(100),
    etl_job_nm varchar(100),
    etl_ld_time timestamp,
    CONSTRAINT C_PRIMARY PRIMARY KEY (object_id) ENABLED
);

COMMENT ON TABLE DL_ODS_INFO.s034_wfdb_asharedescription IS '中国债券基本资料';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.object_id IS '对象ID';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.s_info_windcode IS 'Wind代码';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.s_info_code IS '交易代码';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.s_info_name IS '证券简称';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.s_info_compname IS '公司中文名称';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.s_info_compnameeng IS '公司英文名称';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.s_info_isincode IS 'ISIN代码';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.s_info_exchmarket IS '交易所';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.s_info_listboard IS '上市板类型';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.s_info_listdate IS '上市日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.s_info_delistdate IS '退市日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.s_info_sedolcode IS '废弃';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.crncy_code IS '货币代码';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.s_info_pinyin IS '简称拼音';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.s_info_listboardname IS '上市板';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.is_shsc IS '是否在沪股通或深股通范围内';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.s_info_compcode IS '公司ID';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.opdate IS '万得日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.opmode IS '更新标志';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.clientopdate IS '数据更新日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.clientadddate IS '数据加入日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.mopdate IS '万得日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.etl_btch_dt IS '技术字段批量日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.etl_src_tbl_nm IS '技术字段来源表';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.etl_job_nm IS '技术字段ETL JOB 名称';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_asharedescription.etl_ld_time IS '技术字段ETL加工时间';


CREATE PROJECTION DL_ODS_INFO.s034_wfdb_asharedescription_super /*+basename(s034_wfdb_asharedescription),createtype(P)*/ 
(
 object_id,
 s_info_windcode,
 s_info_code,
 s_info_name,
 s_info_compname,
 s_info_compnameeng,
 s_info_isincode,
 s_info_exchmarket,
 s_info_listboard,
 s_info_listdate,
 s_info_delistdate,
 s_info_sedolcode,
 crncy_code,
 s_info_pinyin,
 s_info_listboardname,
 is_shsc,
 s_info_compcode,
 opdate,
 opmode,
 clientopdate,
 clientadddate,
 mopdate,
 etl_btch_dt,
 etl_src_tbl_nm,
 etl_job_nm,
 etl_ld_time
)
AS
 SELECT s034_wfdb_asharedescription.object_id,
        s034_wfdb_asharedescription.s_info_windcode,
        s034_wfdb_asharedescription.s_info_code,
        s034_wfdb_asharedescription.s_info_name,
        s034_wfdb_asharedescription.s_info_compname,
        s034_wfdb_asharedescription.s_info_compnameeng,
        s034_wfdb_asharedescription.s_info_isincode,
        s034_wfdb_asharedescription.s_info_exchmarket,
        s034_wfdb_asharedescription.s_info_listboard,
        s034_wfdb_asharedescription.s_info_listdate,
        s034_wfdb_asharedescription.s_info_delistdate,
        s034_wfdb_asharedescription.s_info_sedolcode,
        s034_wfdb_asharedescription.crncy_code,
        s034_wfdb_asharedescription.s_info_pinyin,
        s034_wfdb_asharedescription.s_info_listboardname,
        s034_wfdb_asharedescription.is_shsc,
        s034_wfdb_asharedescription.s_info_compcode,
        s034_wfdb_asharedescription.opdate,
        s034_wfdb_asharedescription.opmode,
        s034_wfdb_asharedescription.clientopdate,
        s034_wfdb_asharedescription.clientadddate,
        s034_wfdb_asharedescription.mopdate,
        s034_wfdb_asharedescription.etl_btch_dt,
        s034_wfdb_asharedescription.etl_src_tbl_nm,
        s034_wfdb_asharedescription.etl_job_nm,
        s034_wfdb_asharedescription.etl_ld_time
 FROM DL_ODS_INFO.s034_wfdb_asharedescription
 ORDER BY s034_wfdb_asharedescription.object_id,
          s034_wfdb_asharedescription.s_info_windcode,
          s034_wfdb_asharedescription.s_info_code,
          s034_wfdb_asharedescription.s_info_name,
          s034_wfdb_asharedescription.s_info_compname,
          s034_wfdb_asharedescription.s_info_compnameeng,
          s034_wfdb_asharedescription.s_info_isincode,
          s034_wfdb_asharedescription.s_info_exchmarket,
          s034_wfdb_asharedescription.s_info_listboard,
          s034_wfdb_asharedescription.s_info_listdate,
          s034_wfdb_asharedescription.s_info_delistdate,
          s034_wfdb_asharedescription.s_info_sedolcode,
          s034_wfdb_asharedescription.crncy_code,
          s034_wfdb_asharedescription.s_info_pinyin,
          s034_wfdb_asharedescription.s_info_listboardname,
          s034_wfdb_asharedescription.is_shsc,
          s034_wfdb_asharedescription.s_info_compcode,
          s034_wfdb_asharedescription.opdate,
          s034_wfdb_asharedescription.opmode,
          s034_wfdb_asharedescription.clientopdate,
          s034_wfdb_asharedescription.clientadddate,
          s034_wfdb_asharedescription.mopdate
SEGMENTED BY hash(s034_wfdb_asharedescription.object_id) ALL NODES;


SELECT MARK_DESIGN_KSAFE(1);

CREATE TABLE DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd
(
    object_id varchar(200) NOT NULL,
    s_info_windcode varchar(100),
    trade_dt varchar(100),
    b_anal_matu_cnbd numeric(20,4),
    b_anal_dirty_cnbd numeric(20,4),
    b_anal_accrint_cnbd numeric(20,4),
    b_anal_net_cnbd numeric(20,4),
    b_anal_yield_cnbd numeric(20,4),
    b_anal_modidura_cnbd numeric(20,4),
    b_anal_cnvxty_cnbd numeric(20,4),
    b_anal_vobp_cnbd numeric(20,4),
    b_anal_sprdura_cnbd numeric(20,4),
    b_anal_sprcnxt_cnbd numeric(20,4),
    b_anal_accrintclose_cnbd numeric(20,4),
    b_anal_price numeric(20,4),
    b_anal_netprice numeric(20,4),
    b_anal_yield numeric(20,4),
    b_anal_modifiedduration numeric(20,4),
    b_anal_convexity numeric(20,4),
    b_anal_bpvalue numeric(20,4),
    b_anal_sduration numeric(20,4),
    b_anal_scnvxty numeric(20,4),
    b_anal_interestduration_cnbd numeric(20,4),
    b_anal_interestcnvxty_cnbd numeric(20,4),
    b_anal_interestduration numeric(20,4),
    b_anal_interestcnvxty numeric(20,4),
    b_anal_price_cnbd numeric(20,4),
    b_anal_bpyield numeric(20,4),
    b_anal_exchange varchar(100),
    b_anal_credibility varchar(100),
    b_anal_residualpri numeric(20,4),
    b_anal_exercise_rate numeric(20,6),
    opdate date,
    opmode varchar(100),
    clientopdate date,
    clientadddate date,
    mopdate date,
    etl_btch_dt date,
    etl_src_tbl_nm varchar(100),
    etl_job_nm varchar(100),
    etl_ld_time timestamp,
    CONSTRAINT C_PRIMARY PRIMARY KEY (object_id) ENABLED
);

COMMENT ON TABLE DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd IS '中债登估值(废弃)';


CREATE PROJECTION DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0
(
 object_id,
 s_info_windcode,
 trade_dt,
 b_anal_matu_cnbd,
 b_anal_dirty_cnbd,
 b_anal_accrint_cnbd,
 b_anal_net_cnbd,
 b_anal_yield_cnbd,
 b_anal_modidura_cnbd,
 b_anal_cnvxty_cnbd,
 b_anal_vobp_cnbd,
 b_anal_sprdura_cnbd,
 b_anal_sprcnxt_cnbd,
 b_anal_accrintclose_cnbd,
 b_anal_price,
 b_anal_netprice,
 b_anal_yield,
 b_anal_modifiedduration,
 b_anal_convexity,
 b_anal_bpvalue,
 b_anal_sduration,
 b_anal_scnvxty,
 b_anal_interestduration_cnbd,
 b_anal_interestcnvxty_cnbd,
 b_anal_interestduration,
 b_anal_interestcnvxty,
 b_anal_price_cnbd,
 b_anal_bpyield,
 b_anal_exchange,
 b_anal_credibility,
 b_anal_residualpri,
 b_anal_exercise_rate,
 opdate,
 opmode,
 clientopdate,
 clientadddate,
 mopdate,
 etl_btch_dt,
 etl_src_tbl_nm,
 etl_job_nm,
 etl_ld_time
)
AS
 SELECT s034_wfdb_cbondanalysiscnbd.object_id,
        s034_wfdb_cbondanalysiscnbd.s_info_windcode,
        s034_wfdb_cbondanalysiscnbd.trade_dt,
        s034_wfdb_cbondanalysiscnbd.b_anal_matu_cnbd,
        s034_wfdb_cbondanalysiscnbd.b_anal_dirty_cnbd,
        s034_wfdb_cbondanalysiscnbd.b_anal_accrint_cnbd,
        s034_wfdb_cbondanalysiscnbd.b_anal_net_cnbd,
        s034_wfdb_cbondanalysiscnbd.b_anal_yield_cnbd,
        s034_wfdb_cbondanalysiscnbd.b_anal_modidura_cnbd,
        s034_wfdb_cbondanalysiscnbd.b_anal_cnvxty_cnbd,
        s034_wfdb_cbondanalysiscnbd.b_anal_vobp_cnbd,
        s034_wfdb_cbondanalysiscnbd.b_anal_sprdura_cnbd,
        s034_wfdb_cbondanalysiscnbd.b_anal_sprcnxt_cnbd,
        s034_wfdb_cbondanalysiscnbd.b_anal_accrintclose_cnbd,
        s034_wfdb_cbondanalysiscnbd.b_anal_price,
        s034_wfdb_cbondanalysiscnbd.b_anal_netprice,
        s034_wfdb_cbondanalysiscnbd.b_anal_yield,
        s034_wfdb_cbondanalysiscnbd.b_anal_modifiedduration,
        s034_wfdb_cbondanalysiscnbd.b_anal_convexity,
        s034_wfdb_cbondanalysiscnbd.b_anal_bpvalue,
        s034_wfdb_cbondanalysiscnbd.b_anal_sduration,
        s034_wfdb_cbondanalysiscnbd.b_anal_scnvxty,
        s034_wfdb_cbondanalysiscnbd.b_anal_interestduration_cnbd,
        s034_wfdb_cbondanalysiscnbd.b_anal_interestcnvxty_cnbd,
        s034_wfdb_cbondanalysiscnbd.b_anal_interestduration,
        s034_wfdb_cbondanalysiscnbd.b_anal_interestcnvxty,
        s034_wfdb_cbondanalysiscnbd.b_anal_price_cnbd,
        s034_wfdb_cbondanalysiscnbd.b_anal_bpyield,
        s034_wfdb_cbondanalysiscnbd.b_anal_exchange,
        s034_wfdb_cbondanalysiscnbd.b_anal_credibility,
        s034_wfdb_cbondanalysiscnbd.b_anal_residualpri,
        s034_wfdb_cbondanalysiscnbd.b_anal_exercise_rate,
        s034_wfdb_cbondanalysiscnbd.opdate,
        s034_wfdb_cbondanalysiscnbd.opmode,
        s034_wfdb_cbondanalysiscnbd.clientopdate,
        s034_wfdb_cbondanalysiscnbd.clientadddate,
        s034_wfdb_cbondanalysiscnbd.mopdate,
        s034_wfdb_cbondanalysiscnbd.etl_btch_dt,
        s034_wfdb_cbondanalysiscnbd.etl_src_tbl_nm,
        s034_wfdb_cbondanalysiscnbd.etl_job_nm,
        s034_wfdb_cbondanalysiscnbd.etl_ld_time
 FROM DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd
 ORDER BY s034_wfdb_cbondanalysiscnbd.object_id,
          s034_wfdb_cbondanalysiscnbd.s_info_windcode,
          s034_wfdb_cbondanalysiscnbd.trade_dt,
          s034_wfdb_cbondanalysiscnbd.b_anal_matu_cnbd,
          s034_wfdb_cbondanalysiscnbd.b_anal_dirty_cnbd,
          s034_wfdb_cbondanalysiscnbd.b_anal_accrint_cnbd,
          s034_wfdb_cbondanalysiscnbd.b_anal_net_cnbd,
          s034_wfdb_cbondanalysiscnbd.b_anal_yield_cnbd,
          s034_wfdb_cbondanalysiscnbd.b_anal_modidura_cnbd,
          s034_wfdb_cbondanalysiscnbd.b_anal_cnvxty_cnbd,
          s034_wfdb_cbondanalysiscnbd.b_anal_vobp_cnbd,
          s034_wfdb_cbondanalysiscnbd.b_anal_sprdura_cnbd,
          s034_wfdb_cbondanalysiscnbd.b_anal_sprcnxt_cnbd,
          s034_wfdb_cbondanalysiscnbd.b_anal_accrintclose_cnbd,
          s034_wfdb_cbondanalysiscnbd.b_anal_price,
          s034_wfdb_cbondanalysiscnbd.b_anal_netprice,
          s034_wfdb_cbondanalysiscnbd.b_anal_yield,
          s034_wfdb_cbondanalysiscnbd.b_anal_modifiedduration,
          s034_wfdb_cbondanalysiscnbd.b_anal_convexity,
          s034_wfdb_cbondanalysiscnbd.b_anal_bpvalue,
          s034_wfdb_cbondanalysiscnbd.b_anal_sduration,
          s034_wfdb_cbondanalysiscnbd.b_anal_scnvxty,
          s034_wfdb_cbondanalysiscnbd.b_anal_interestduration_cnbd,
          s034_wfdb_cbondanalysiscnbd.b_anal_interestcnvxty_cnbd,
          s034_wfdb_cbondanalysiscnbd.b_anal_interestduration,
          s034_wfdb_cbondanalysiscnbd.b_anal_interestcnvxty,
          s034_wfdb_cbondanalysiscnbd.b_anal_price_cnbd,
          s034_wfdb_cbondanalysiscnbd.b_anal_bpyield,
          s034_wfdb_cbondanalysiscnbd.b_anal_exchange,
          s034_wfdb_cbondanalysiscnbd.b_anal_credibility,
          s034_wfdb_cbondanalysiscnbd.b_anal_residualpri,
          s034_wfdb_cbondanalysiscnbd.b_anal_exercise_rate,
          s034_wfdb_cbondanalysiscnbd.opdate,
          s034_wfdb_cbondanalysiscnbd.opmode,
          s034_wfdb_cbondanalysiscnbd.clientopdate,
          s034_wfdb_cbondanalysiscnbd.clientadddate,
          s034_wfdb_cbondanalysiscnbd.mopdate
SEGMENTED BY hash(s034_wfdb_cbondanalysiscnbd.object_id) ALL NODES;

COMMENT ON PROJECTION DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0 IS '中债登估值(废弃)';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."object_id" IS '对象ID';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."s_info_windcode" IS 'Wind代码';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."trade_dt" IS '交易日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_matu_cnbd" IS '待偿期(年)';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_dirty_cnbd" IS '估价全价';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_accrint_cnbd" IS '应计利息';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_net_cnbd" IS '估价净价';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_yield_cnbd" IS '估价收益率(%)';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_modidura_cnbd" IS '估价修正久期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_cnvxty_cnbd" IS '估价凸性';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_vobp_cnbd" IS '估价基点价值';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_sprdura_cnbd" IS '估价利差久期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_sprcnxt_cnbd" IS '估价利差凸性';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_accrintclose_cnbd" IS '日终应计利息';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_price" IS '市场全价';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_netprice" IS '市场净价';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_yield" IS '市场收益率(%)';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_modifiedduration" IS '市场修正久期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_convexity" IS '市场凸性';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_bpvalue" IS '市场基点价值';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_sduration" IS '市场利差久期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_scnvxty" IS '市场利差凸性';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_interestduration_cnbd" IS '估价利率久期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_interestcnvxty_cnbd" IS '估价利率凸性';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_interestduration" IS '市场利率久期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_interestcnvxty" IS '市场利率凸性';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_price_cnbd" IS '日终估价全价';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_bpyield" IS '点差收益率(%)';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_exchange" IS '流通场所';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_credibility" IS '可信度';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_residualpri" IS '剩余本金';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."b_anal_exercise_rate" IS '估算的行权后票面利率';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."opdate" IS '万得日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."opmode" IS '更新标志';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."clientopdate" IS '数据更新日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."clientadddate" IS '数据加入日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."mopdate" IS '万得日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."etl_btch_dt" IS '技术字段批量日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."etl_src_tbl_nm" IS '技术字段来源表';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."etl_job_nm" IS '技术字段ETL JOB 名称';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_cbondanalysiscnbd_b0."etl_ld_time" IS '技术字段ETL加工时间';


SELECT MARK_DESIGN_KSAFE(1);

CREATE TABLE DL_ODS_INFO.s034_wfdb_chinamutualfunddescription
(
    object_id varchar(200) NOT NULL,
    f_info_windcode varchar(100),
    f_info_front_code varchar(100),
    f_info_backend_code varchar(100),
    f_info_fullname varchar(200),
    f_info_name varchar(200),
    f_info_corp_fundmanagementcomp varchar(200),
    f_info_custodianbank varchar(200),
    f_info_firstinvesttype varchar(100),
    f_info_setupdate varchar(100),
    f_info_maturitydate varchar(100),
    f_issue_totalunit numeric(26,10),
    f_info_managementfeeratio numeric(20,4),
    f_info_custodianfeeratio numeric(20,4),
    crny_code varchar(100),
    f_info_ptmyear numeric(20,4),
    f_issue_oef_startdateinst varchar(100),
    f_issue_oef_dnddateinst varchar(100),
    f_info_parvalue numeric(20,4),
    f_info_trusttype varchar(100),
    f_info_trustee varchar(200),
    f_pchredm_pchstartdate varchar(100),
    f_info_redmstartdate varchar(100),
    f_info_minbuyamount numeric(20,6),
    f_info_expectedrateofreturn numeric(20,4),
    f_info_issuingplace varchar(200),
    f_info_benchmark varchar(1000),
    f_info_status numeric(9,0),
    f_info_restrictedornot varchar(100),
    f_info_structuredornot numeric(1,0),
    f_info_exchmarket varchar(100),
    f_info_firstinveststyle varchar(100),
    f_info_issuedate varchar(100),
    f_info_type varchar(100),
    f_info_isinitial numeric(5,0),
    f_info_pinyin varchar(100),
    f_info_investscope varchar(6000),
    f_info_investobject varchar(2000),
    f_info_investconception varchar(4000),
    f_info_decision_basis varchar(4000),
    is_indexfund numeric(5,0),
    f_info_delistdate varchar(100),
    f_info_corp_fundmanagementid varchar(100),
    f_info_custodianbankid varchar(100),
    max_num_holder numeric(20,4),
    max_num_coltarget numeric(20,4),
    investstrategy char(4),
    risk_return char(4),
    f_pchredm_pchminamt numeric(20,4),
    f_pchredm_pchminamt_ex numeric(20,4),
    f_info_listdate varchar(100),
    f_info_anndate varchar(100),
    f_closed_operation_period numeric(20,4),
    f_closed_operation_interval numeric(20,4),
    f_info_registrant varchar(100),
    f_personal_startdateind varchar(100),
    f_personal_enddateind varchar(100),
    opdate date,
    opmode varchar(100),
    clientopdate date,
    clientadddate date,
    mopdate date,
    etl_btch_dt date,
    etl_src_tbl_nm varchar(100),
    etl_job_nm varchar(100),
    etl_ld_time timestamp,
    CONSTRAINT C_PRIMARY PRIMARY KEY (object_id) ENABLED
);

COMMENT ON TABLE DL_ODS_INFO.s034_wfdb_chinamutualfunddescription IS '中国共同基金基本资料';

COMMENT ON TABLE DL_ODS_INFO.s034_wfdb_chinamutualfunddescription IS '0';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.object_id IS '对象ID';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_windcode IS 'Wind代码';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_front_code IS '前端代码';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_backend_code IS '后端代码';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_fullname IS '名称';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_name IS '简称';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_corp_fundmanagementcomp IS '管理人';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_custodianbank IS '托管人';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_firstinvesttype IS '投资类型';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_setupdate IS '成立日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_maturitydate IS '到期日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_issue_totalunit IS '发行份额';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_managementfeeratio IS '管理费';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_custodianfeeratio IS '托管费';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.crny_code IS '货币代码';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_ptmyear IS '存续期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_issue_oef_startdateinst IS '机构投资者认购起始日';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_issue_oef_dnddateinst IS '机构投资者认购终止日';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_parvalue IS '面值';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_trusttype IS '信托类别';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_trustee IS '受托人';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_pchredm_pchstartdate IS '日常申购起始日';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_redmstartdate IS '日常赎回起始日';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_minbuyamount IS '起点金额';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_expectedrateofreturn IS '预期收益率';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_issuingplace IS '发行地';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_benchmark IS '业绩比较基准';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_status IS '存续状态';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_restrictedornot IS '限定类型';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_structuredornot IS '是否结构化产品';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_exchmarket IS '交易所';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_firstinveststyle IS '投资风格';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_issuedate IS '发行日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_type IS '基金类型';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_isinitial IS '是否为初始基金';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_pinyin IS '简称拼音';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_investscope IS '投资范围';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_investobject IS '投资目标';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_investconception IS '投资理念';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_decision_basis IS '决策依据';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.is_indexfund IS '是否指数基金';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_delistdate IS '退市日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_corp_fundmanagementid IS '基金管理人ID';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_custodianbankid IS '托管人id';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.max_num_holder IS '单一投资者持有份额上限(亿份)';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.max_num_coltarget IS '封闭期目标募集数量上限(亿份)';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.investstrategy IS '投资策略';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.risk_return IS '基金风险收益特征';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_pchredm_pchminamt IS '每次最低申购金额(场外)(万元)';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_pchredm_pchminamt_ex IS '每次最低申购金额(场内) (万元)';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_listdate IS '上市时间';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_anndate IS '公告日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_closed_operation_period IS '封闭运作期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_closed_operation_interval IS '封闭运作期满开放日间隔';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_info_registrant IS '基金注册与过户登记人ID';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_personal_startdateind IS '个人投资者认购起始日';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.f_personal_enddateind IS '个人投资者认购终止日';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.opdate IS '万得日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.opmode IS '更新标志';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.clientopdate IS '数据更新日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.clientadddate IS '数据加入日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.mopdate IS '万得日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.etl_btch_dt IS '技术字段批量日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.etl_src_tbl_nm IS '技术字段来源表';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.etl_job_nm IS '技术字段ETL JOB 名称';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfunddescription.etl_ld_time IS '技术字段ETL加工时间';


CREATE PROJECTION DL_ODS_INFO.s034_wfdb_chinamutualfunddescription_super /*+basename(s034_wfdb_chinamutualfunddescription),createtype(P)*/ 
(
 object_id,
 f_info_windcode,
 f_info_front_code,
 f_info_backend_code,
 f_info_fullname,
 f_info_name,
 f_info_corp_fundmanagementcomp,
 f_info_custodianbank,
 f_info_firstinvesttype,
 f_info_setupdate,
 f_info_maturitydate,
 f_issue_totalunit,
 f_info_managementfeeratio,
 f_info_custodianfeeratio,
 crny_code,
 f_info_ptmyear,
 f_issue_oef_startdateinst,
 f_issue_oef_dnddateinst,
 f_info_parvalue,
 f_info_trusttype,
 f_info_trustee,
 f_pchredm_pchstartdate,
 f_info_redmstartdate,
 f_info_minbuyamount,
 f_info_expectedrateofreturn,
 f_info_issuingplace,
 f_info_benchmark,
 f_info_status,
 f_info_restrictedornot,
 f_info_structuredornot,
 f_info_exchmarket,
 f_info_firstinveststyle,
 f_info_issuedate,
 f_info_type,
 f_info_isinitial,
 f_info_pinyin,
 f_info_investscope,
 f_info_investobject,
 f_info_investconception,
 f_info_decision_basis,
 is_indexfund,
 f_info_delistdate,
 f_info_corp_fundmanagementid,
 f_info_custodianbankid,
 max_num_holder,
 max_num_coltarget,
 investstrategy,
 risk_return,
 f_pchredm_pchminamt,
 f_pchredm_pchminamt_ex,
 f_info_listdate,
 f_info_anndate,
 f_closed_operation_period,
 f_closed_operation_interval,
 f_info_registrant,
 f_personal_startdateind,
 f_personal_enddateind,
 opdate,
 opmode,
 clientopdate,
 clientadddate,
 mopdate,
 etl_btch_dt,
 etl_src_tbl_nm,
 etl_job_nm,
 etl_ld_time
)
AS
 SELECT s034_wfdb_chinamutualfunddescription.object_id,
        s034_wfdb_chinamutualfunddescription.f_info_windcode,
        s034_wfdb_chinamutualfunddescription.f_info_front_code,
        s034_wfdb_chinamutualfunddescription.f_info_backend_code,
        s034_wfdb_chinamutualfunddescription.f_info_fullname,
        s034_wfdb_chinamutualfunddescription.f_info_name,
        s034_wfdb_chinamutualfunddescription.f_info_corp_fundmanagementcomp,
        s034_wfdb_chinamutualfunddescription.f_info_custodianbank,
        s034_wfdb_chinamutualfunddescription.f_info_firstinvesttype,
        s034_wfdb_chinamutualfunddescription.f_info_setupdate,
        s034_wfdb_chinamutualfunddescription.f_info_maturitydate,
        s034_wfdb_chinamutualfunddescription.f_issue_totalunit,
        s034_wfdb_chinamutualfunddescription.f_info_managementfeeratio,
        s034_wfdb_chinamutualfunddescription.f_info_custodianfeeratio,
        s034_wfdb_chinamutualfunddescription.crny_code,
        s034_wfdb_chinamutualfunddescription.f_info_ptmyear,
        s034_wfdb_chinamutualfunddescription.f_issue_oef_startdateinst,
        s034_wfdb_chinamutualfunddescription.f_issue_oef_dnddateinst,
        s034_wfdb_chinamutualfunddescription.f_info_parvalue,
        s034_wfdb_chinamutualfunddescription.f_info_trusttype,
        s034_wfdb_chinamutualfunddescription.f_info_trustee,
        s034_wfdb_chinamutualfunddescription.f_pchredm_pchstartdate,
        s034_wfdb_chinamutualfunddescription.f_info_redmstartdate,
        s034_wfdb_chinamutualfunddescription.f_info_minbuyamount,
        s034_wfdb_chinamutualfunddescription.f_info_expectedrateofreturn,
        s034_wfdb_chinamutualfunddescription.f_info_issuingplace,
        s034_wfdb_chinamutualfunddescription.f_info_benchmark,
        s034_wfdb_chinamutualfunddescription.f_info_status,
        s034_wfdb_chinamutualfunddescription.f_info_restrictedornot,
        s034_wfdb_chinamutualfunddescription.f_info_structuredornot,
        s034_wfdb_chinamutualfunddescription.f_info_exchmarket,
        s034_wfdb_chinamutualfunddescription.f_info_firstinveststyle,
        s034_wfdb_chinamutualfunddescription.f_info_issuedate,
        s034_wfdb_chinamutualfunddescription.f_info_type,
        s034_wfdb_chinamutualfunddescription.f_info_isinitial,
        s034_wfdb_chinamutualfunddescription.f_info_pinyin,
        s034_wfdb_chinamutualfunddescription.f_info_investscope,
        s034_wfdb_chinamutualfunddescription.f_info_investobject,
        s034_wfdb_chinamutualfunddescription.f_info_investconception,
        s034_wfdb_chinamutualfunddescription.f_info_decision_basis,
        s034_wfdb_chinamutualfunddescription.is_indexfund,
        s034_wfdb_chinamutualfunddescription.f_info_delistdate,
        s034_wfdb_chinamutualfunddescription.f_info_corp_fundmanagementid,
        s034_wfdb_chinamutualfunddescription.f_info_custodianbankid,
        s034_wfdb_chinamutualfunddescription.max_num_holder,
        s034_wfdb_chinamutualfunddescription.max_num_coltarget,
        s034_wfdb_chinamutualfunddescription.investstrategy,
        s034_wfdb_chinamutualfunddescription.risk_return,
        s034_wfdb_chinamutualfunddescription.f_pchredm_pchminamt,
        s034_wfdb_chinamutualfunddescription.f_pchredm_pchminamt_ex,
        s034_wfdb_chinamutualfunddescription.f_info_listdate,
        s034_wfdb_chinamutualfunddescription.f_info_anndate,
        s034_wfdb_chinamutualfunddescription.f_closed_operation_period,
        s034_wfdb_chinamutualfunddescription.f_closed_operation_interval,
        s034_wfdb_chinamutualfunddescription.f_info_registrant,
        s034_wfdb_chinamutualfunddescription.f_personal_startdateind,
        s034_wfdb_chinamutualfunddescription.f_personal_enddateind,
        s034_wfdb_chinamutualfunddescription.opdate,
        s034_wfdb_chinamutualfunddescription.opmode,
        s034_wfdb_chinamutualfunddescription.clientopdate,
        s034_wfdb_chinamutualfunddescription.clientadddate,
        s034_wfdb_chinamutualfunddescription.mopdate,
        s034_wfdb_chinamutualfunddescription.etl_btch_dt,
        s034_wfdb_chinamutualfunddescription.etl_src_tbl_nm,
        s034_wfdb_chinamutualfunddescription.etl_job_nm,
        s034_wfdb_chinamutualfunddescription.etl_ld_time
 FROM DL_ODS_INFO.s034_wfdb_chinamutualfunddescription
 ORDER BY s034_wfdb_chinamutualfunddescription.object_id,
          s034_wfdb_chinamutualfunddescription.f_info_windcode,
          s034_wfdb_chinamutualfunddescription.f_info_front_code,
          s034_wfdb_chinamutualfunddescription.f_info_backend_code,
          s034_wfdb_chinamutualfunddescription.f_info_fullname,
          s034_wfdb_chinamutualfunddescription.f_info_name,
          s034_wfdb_chinamutualfunddescription.f_info_corp_fundmanagementcomp,
          s034_wfdb_chinamutualfunddescription.f_info_custodianbank,
          s034_wfdb_chinamutualfunddescription.f_info_firstinvesttype,
          s034_wfdb_chinamutualfunddescription.f_info_setupdate,
          s034_wfdb_chinamutualfunddescription.f_info_maturitydate,
          s034_wfdb_chinamutualfunddescription.f_issue_totalunit,
          s034_wfdb_chinamutualfunddescription.f_info_managementfeeratio,
          s034_wfdb_chinamutualfunddescription.f_info_custodianfeeratio,
          s034_wfdb_chinamutualfunddescription.crny_code,
          s034_wfdb_chinamutualfunddescription.f_info_ptmyear,
          s034_wfdb_chinamutualfunddescription.f_issue_oef_startdateinst,
          s034_wfdb_chinamutualfunddescription.f_issue_oef_dnddateinst,
          s034_wfdb_chinamutualfunddescription.f_info_parvalue,
          s034_wfdb_chinamutualfunddescription.f_info_trusttype,
          s034_wfdb_chinamutualfunddescription.f_info_trustee,
          s034_wfdb_chinamutualfunddescription.f_pchredm_pchstartdate,
          s034_wfdb_chinamutualfunddescription.f_info_redmstartdate,
          s034_wfdb_chinamutualfunddescription.f_info_minbuyamount,
          s034_wfdb_chinamutualfunddescription.f_info_expectedrateofreturn,
          s034_wfdb_chinamutualfunddescription.f_info_issuingplace,
          s034_wfdb_chinamutualfunddescription.f_info_benchmark,
          s034_wfdb_chinamutualfunddescription.f_info_status,
          s034_wfdb_chinamutualfunddescription.f_info_restrictedornot,
          s034_wfdb_chinamutualfunddescription.f_info_structuredornot,
          s034_wfdb_chinamutualfunddescription.f_info_exchmarket,
          s034_wfdb_chinamutualfunddescription.f_info_firstinveststyle,
          s034_wfdb_chinamutualfunddescription.f_info_issuedate,
          s034_wfdb_chinamutualfunddescription.f_info_type,
          s034_wfdb_chinamutualfunddescription.f_info_isinitial,
          s034_wfdb_chinamutualfunddescription.f_info_pinyin,
          s034_wfdb_chinamutualfunddescription.f_info_investscope,
          s034_wfdb_chinamutualfunddescription.f_info_investobject,
          s034_wfdb_chinamutualfunddescription.f_info_investconception,
          s034_wfdb_chinamutualfunddescription.f_info_decision_basis,
          s034_wfdb_chinamutualfunddescription.is_indexfund,
          s034_wfdb_chinamutualfunddescription.f_info_delistdate,
          s034_wfdb_chinamutualfunddescription.f_info_corp_fundmanagementid,
          s034_wfdb_chinamutualfunddescription.f_info_custodianbankid,
          s034_wfdb_chinamutualfunddescription.max_num_holder,
          s034_wfdb_chinamutualfunddescription.max_num_coltarget,
          s034_wfdb_chinamutualfunddescription.investstrategy,
          s034_wfdb_chinamutualfunddescription.risk_return,
          s034_wfdb_chinamutualfunddescription.f_pchredm_pchminamt,
          s034_wfdb_chinamutualfunddescription.f_pchredm_pchminamt_ex,
          s034_wfdb_chinamutualfunddescription.f_info_listdate,
          s034_wfdb_chinamutualfunddescription.f_info_anndate,
          s034_wfdb_chinamutualfunddescription.f_closed_operation_period,
          s034_wfdb_chinamutualfunddescription.f_closed_operation_interval,
          s034_wfdb_chinamutualfunddescription.f_info_registrant,
          s034_wfdb_chinamutualfunddescription.f_personal_startdateind,
          s034_wfdb_chinamutualfunddescription.f_personal_enddateind,
          s034_wfdb_chinamutualfunddescription.opdate,
          s034_wfdb_chinamutualfunddescription.opmode,
          s034_wfdb_chinamutualfunddescription.clientopdate,
          s034_wfdb_chinamutualfunddescription.clientadddate,
          s034_wfdb_chinamutualfunddescription.mopdate
SEGMENTED BY hash(s034_wfdb_chinamutualfunddescription.object_id) ALL NODES;


SELECT MARK_DESIGN_KSAFE(1);

CREATE TABLE DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio
(
    object_id varchar(200),
    s_info_windcode varchar(100),
    f_prt_enddate varchar(100),
    crncy_code varchar(100),
    s_info_stockwindcode varchar(100),
    f_prt_stkvalue numeric(20,4),
    f_prt_stkquantity numeric(20,4),
    f_prt_stkvaluetonav numeric(20,4),
    f_prt_posstkvalue numeric(20,4),
    f_prt_posstkquantity numeric(20,4),
    f_prt_posstktonav numeric(20,4),
    f_prt_passtkevalue numeric(20,4),
    f_prt_passtkquantity numeric(20,4),
    f_prt_passtktonav numeric(20,4),
    ann_date varchar(100),
    stock_per numeric(20,8),
    float_shr_per numeric(24,8),
    opdate date,
    opmode varchar(100),
    clientopdate date,
    clientadddate date,
    mopdate date,
    etl_btch_dt date,
    etl_src_tbl_nm varchar(100),
    etl_job_nm varchar(100),
    etl_ld_time timestamp
);

COMMENT ON TABLE DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio IS '中国共同基金投资组合—持股明细';


CREATE PROJECTION DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0
(
 object_id,
 s_info_windcode,
 f_prt_enddate,
 crncy_code,
 s_info_stockwindcode,
 f_prt_stkvalue,
 f_prt_stkquantity,
 f_prt_stkvaluetonav,
 f_prt_posstkvalue,
 f_prt_posstkquantity,
 f_prt_posstktonav,
 f_prt_passtkevalue,
 f_prt_passtkquantity,
 f_prt_passtktonav,
 ann_date,
 stock_per,
 float_shr_per,
 opdate,
 opmode,
 clientopdate,
 clientadddate,
 mopdate,
 etl_btch_dt,
 etl_src_tbl_nm,
 etl_job_nm,
 etl_ld_time
)
AS
 SELECT s034_wfdb_chinamutualfundstockportfolio.object_id,
        s034_wfdb_chinamutualfundstockportfolio.s_info_windcode,
        s034_wfdb_chinamutualfundstockportfolio.f_prt_enddate,
        s034_wfdb_chinamutualfundstockportfolio.crncy_code,
        s034_wfdb_chinamutualfundstockportfolio.s_info_stockwindcode,
        s034_wfdb_chinamutualfundstockportfolio.f_prt_stkvalue,
        s034_wfdb_chinamutualfundstockportfolio.f_prt_stkquantity,
        s034_wfdb_chinamutualfundstockportfolio.f_prt_stkvaluetonav,
        s034_wfdb_chinamutualfundstockportfolio.f_prt_posstkvalue,
        s034_wfdb_chinamutualfundstockportfolio.f_prt_posstkquantity,
        s034_wfdb_chinamutualfundstockportfolio.f_prt_posstktonav,
        s034_wfdb_chinamutualfundstockportfolio.f_prt_passtkevalue,
        s034_wfdb_chinamutualfundstockportfolio.f_prt_passtkquantity,
        s034_wfdb_chinamutualfundstockportfolio.f_prt_passtktonav,
        s034_wfdb_chinamutualfundstockportfolio.ann_date,
        s034_wfdb_chinamutualfundstockportfolio.stock_per,
        s034_wfdb_chinamutualfundstockportfolio.float_shr_per,
        s034_wfdb_chinamutualfundstockportfolio.opdate,
        s034_wfdb_chinamutualfundstockportfolio.opmode,
        s034_wfdb_chinamutualfundstockportfolio.clientopdate,
        s034_wfdb_chinamutualfundstockportfolio.clientadddate,
        s034_wfdb_chinamutualfundstockportfolio.mopdate,
        s034_wfdb_chinamutualfundstockportfolio.etl_btch_dt,
        s034_wfdb_chinamutualfundstockportfolio.etl_src_tbl_nm,
        s034_wfdb_chinamutualfundstockportfolio.etl_job_nm,
        s034_wfdb_chinamutualfundstockportfolio.etl_ld_time
 FROM DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio
 ORDER BY s034_wfdb_chinamutualfundstockportfolio.object_id,
          s034_wfdb_chinamutualfundstockportfolio.s_info_windcode,
          s034_wfdb_chinamutualfundstockportfolio.f_prt_enddate,
          s034_wfdb_chinamutualfundstockportfolio.crncy_code,
          s034_wfdb_chinamutualfundstockportfolio.s_info_stockwindcode,
          s034_wfdb_chinamutualfundstockportfolio.f_prt_stkvalue,
          s034_wfdb_chinamutualfundstockportfolio.f_prt_stkquantity,
          s034_wfdb_chinamutualfundstockportfolio.f_prt_stkvaluetonav,
          s034_wfdb_chinamutualfundstockportfolio.f_prt_posstkvalue,
          s034_wfdb_chinamutualfundstockportfolio.f_prt_posstkquantity,
          s034_wfdb_chinamutualfundstockportfolio.f_prt_posstktonav,
          s034_wfdb_chinamutualfundstockportfolio.f_prt_passtkevalue,
          s034_wfdb_chinamutualfundstockportfolio.f_prt_passtkquantity,
          s034_wfdb_chinamutualfundstockportfolio.f_prt_passtktonav,
          s034_wfdb_chinamutualfundstockportfolio.ann_date,
          s034_wfdb_chinamutualfundstockportfolio.stock_per,
          s034_wfdb_chinamutualfundstockportfolio.float_shr_per,
          s034_wfdb_chinamutualfundstockportfolio.opdate,
          s034_wfdb_chinamutualfundstockportfolio.opmode,
          s034_wfdb_chinamutualfundstockportfolio.clientopdate,
          s034_wfdb_chinamutualfundstockportfolio.clientadddate,
          s034_wfdb_chinamutualfundstockportfolio.mopdate
SEGMENTED BY hash(s034_wfdb_chinamutualfundstockportfolio.object_id) ALL NODES;

COMMENT ON PROJECTION DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0 IS '中国共同基金投资组合—持股明细';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."object_id" IS '对象ID';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."s_info_windcode" IS '基金Wind代码';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."f_prt_enddate" IS '截止日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."crncy_code" IS '货币代码';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."s_info_stockwindcode" IS '持有股票Wind代码';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."f_prt_stkvalue" IS '持有股票市值(元)';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."f_prt_stkquantity" IS '持有股票数量（股）';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."f_prt_stkvaluetonav" IS '持有股票市值占基金净值比例(%)';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."f_prt_posstkvalue" IS '积极投资持有股票市值(元)';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."f_prt_posstkquantity" IS '积极投资持有股数（股）';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."f_prt_posstktonav" IS '积极投资持有股票市值占净资产比例(%)';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."f_prt_passtkevalue" IS '指数投资持有股票市值(元)';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."f_prt_passtkquantity" IS '指数投资持有股数（股）';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."f_prt_passtktonav" IS '指数投资持有股票市值占净资产比例(%)';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."ann_date" IS '公告日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."stock_per" IS '占股票市值比';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."float_shr_per" IS '占流通股本比例(%)';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."opdate" IS '万得日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."opmode" IS '更新标志';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."clientopdate" IS '数据更新日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."clientadddate" IS '数据加入日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."mopdate" IS '万得日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."etl_btch_dt" IS '技术字段批量日期';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."etl_src_tbl_nm" IS '技术字段来源表';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."etl_job_nm" IS '技术字段ETL JOB 名称';

COMMENT ON COLUMN DL_ODS_INFO.s034_wfdb_chinamutualfundstockportfolio_b0."etl_ld_time" IS '技术字段ETL加工时间';


SELECT MARK_DESIGN_KSAFE(1);


