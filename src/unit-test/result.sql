SELECT 
    p.prod_cd AS 产品代码,
    p.prod_lvl AS 产品层级,
    p.prod_chn_fll_nm_60001 AS 产品全称,
    p.prod_wind_cd AS Wind代码,
    i.dt AS 数据日期,
    i.indx_id AS 指标ID,
    i.indx_nm AS 指标名称,
    i.indx_vl AS 指标值
FROM 
    CDM.dws_inv_prod_indx_n1 i
JOIN 
    CDM.dim_prod_dmns p ON i.prod_srrg_key = p.prod_srrg_key
WHERE 
    i.indx_id = 'drvi_fnd_mltrtrn01_1d_00' -- 筛选指标ID为组合收益率
    AND p.prod_lvl = '0' -- 筛选产品层级为0（母基金）
    AND p.prod_typ_203427 = '公募' -- 筛选产品类型为公募
ORDER BY 
    i.dt DESC; -- 按数据日期降序排序