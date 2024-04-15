WITH dim_floc AS (
    SELECT
        FLOC_STRNO_FunctionalLocation,
        FLOC_PLTXT_FunctionalLocationDescr,
        FLOC_TPLNR_FunctionalLocationInternalKey
    FROM [myANALYTICS_SP].[silver.dimension.enterprise.asset].[vw_Dim_FunctionalLocation]
),
-- dim_work_order AS (
--     SELECT *
--     FROM [myANALYTICS_SP].[silver.dimension.enterprise.asset].[vw_Dim_WorkOrder]
-- ),
fact_work_order AS (
    SELECT
        AUFNR_Order,
        GLTRP_BasicFinishDateID,
        KTEXT_OrderDescr,
        ILART_MaintenanceActivityTypeID,
        TPLNR_FunctionalLocationInternalID,
        ROW_NUMBER() OVER (PARTITION BY dim_floc.FLOC_STRNO_FunctionalLocation ORDER BY GLTRP_BasicFinishDateID DESC) AS RowNum
    FROM [myANALYTICS_SP].[silver.fact.enterprise.asset].[vw_Fact_WorkOrder]
        LEFT JOIN dim_floc ON dim_floc.FLOC_TPLNR_FunctionalLocationInternalKey = [myANALYTICS_SP].[silver.fact.enterprise.asset].[vw_Fact_WorkOrder].TPLNR_FunctionalLocationInternalID 
    WHERE ILART_MaintenanceActivityTypeID IN
        (
            'C01', 'C14', 'C20', 'C02', 'C13', 'C03', 'C19', 'C23', 'C25', 'C26', 'C10', -- Mechanised Track Maintenance
            'C29', 'C08', 'C42', 'C43', 'C47', 'C51', 'C53', 'C54', 'C50', 'C10', 'C30', 'C48', 'C52', 'C06', 'C07', 'C44', 'C01', 'C57', -- General Track Maintenance
            'B50', 'C67', 'B04',  'B05', 'B06', 'B57', 'C44' -- Structures Maintenance
        )
)

SELECT
	fact_work_order.TPLNR_FunctionalLocationInternalID,
    dim_floc.FLOC_STRNO_FunctionalLocation AS 'floc',
    dim_floc.FLOC_PLTXT_FunctionalLocationDescr AS 'floc_description',
    fact_work_order.AUFNR_Order AS 'last_work_order_id',
    TRY_CAST(fact_work_order.GLTRP_BasicFinishDateID AS date) AS 'last_work_order_basic_finish_date',
    fact_work_order.KTEXT_OrderDescr AS 'last_work_order_desc',
    fact_work_order.ILART_MaintenanceActivityTypeID AS 'activity_type',
    CASE
        WHEN fact_work_order.ILART_MaintenanceActivityTypeID IN ('C01', 'C14', 'C20', 'C02') THEN 'Ballast Undercutting'
        WHEN fact_work_order.ILART_MaintenanceActivityTypeID IN ('C13', 'C03') THEN 'Ballast Undercutting -Turnouts'
        WHEN fact_work_order.ILART_MaintenanceActivityTypeID = 'C19' THEN 'Track Resurfacing'
        WHEN fact_work_order.ILART_MaintenanceActivityTypeID = 'C23' THEN  'Turnout Resurfacing'
        WHEN fact_work_order.ILART_MaintenanceActivityTypeID = 'C25' THEN 'Rail Grinding'
        WHEN fact_work_order.ILART_MaintenanceActivityTypeID IN ('C26', 'C10') THEN 'Turnout Grinding'
        ELSE ''
    END AS 'last_work_order_activity_name'  
FROM dim_floc
    LEFT JOIN fact_work_order ON fact_work_order.TPLNR_FunctionalLocationInternalID = dim_floc.FLOC_TPLNR_FunctionalLocationInternalKey
    -- LEFT JOIN dim_work_order ON something
where
    fact_work_order.RowNum = 1
    -- AND ILART_MaintenanceActivityTypeID = 'C01'
ORDER BY floc