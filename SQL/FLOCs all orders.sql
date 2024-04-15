WITH dim_floc AS (
    SELECT
        FLOC_STRNO_FunctionalLocation,
        FLOC_PLTXT_FunctionalLocationDescr,
        FLOC_TPLNR_FunctionalLocationInternalKey,
		FLOC_EARTX_TechnicalObjectTypeDescr,
        FLOC_MSGRP_FunctionalLocationRoom,
        FLOC_STORT_LocationDescr,
		FLOC_BUKRS_CompanyCode
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
		ActualCost
    FROM [myANALYTICS_SP].[silver.fact.enterprise.asset].[vw_Fact_WorkOrder]
    WHERE ILART_MaintenanceActivityTypeID IN
        (
            'C01', 'C14', 'C20', 'C02', 'C13', 'C03', 'C19', 'C23', 'C25', 'C26', 'C10', -- Mechanised Track Maintenance
            'C29', 'C37', 'C08', 'C47', 'C54', 'C43', 'C51', 'C53', 'C57', 'C50', 'C10', 'C30', 'C48', 'C54', 'C52', 'C06', 'C07', 'C44', 'C01', 'C57', -- General Track Maintenance
            'B50', 'B53', 'C67', 'B04', 'B05', 'B06', 'B55', 'B57', 'C67', -- Structures Maintenance
            'T28', 'T29', 'T40', 'T41', 'T58', 'T44', 'T45', 'T46', 'T47', 'T48', 'T54', 'T42', 'T43', -- Control Systems - Signalling and Wayside Maintenance
            'T10', 'T11', 'T32', -- Control Systems - Telecommunications Maintenance
            'C54', 'T32', -- Control Systems - Operational Systems Maintenance
            'T26', 'T27', 'T32', 'T24', 'T25' -- Traction Power Maintenance
        )
)

SELECT
	--fact_work_order.TPLNR_FunctionalLocationInternalID,
    dim_floc.FLOC_STRNO_FunctionalLocation AS 'floc',
    dim_floc.FLOC_PLTXT_FunctionalLocationDescr AS 'floc_description',
    fact_work_order.AUFNR_Order AS 'work_order_id',
    TRY_CAST(fact_work_order.GLTRP_BasicFinishDateID AS date) AS 'work_order_basic_finish_date',
    fact_work_order.KTEXT_OrderDescr AS 'work_order_desc',
    fact_work_order.ILART_MaintenanceActivityTypeID AS 'activity_type',
    dim_floc.FLOC_EARTX_TechnicalObjectTypeDescr as 'level',
    fact_work_order.ActualCost as 'actual_cost',
    FLOC_MSGRP_FunctionalLocationRoom,
    FLOC_STORT_LocationDescr
FROM dim_floc
    LEFT JOIN fact_work_order ON fact_work_order.TPLNR_FunctionalLocationInternalID = dim_floc.FLOC_TPLNR_FunctionalLocationInternalKey
    -- LEFT JOIN dim_work_order ON something
where
    dim_floc.FLOC_BUKRS_CompanyCode = '5000' -- CompanyCode 5000 = Aurizon Network Pty Ltd (below rail)
    -- fact_work_order.TPLNR_FunctionalLocationInternalID is not null -- this line will filter the result table to only show FLOC_IDs that HAD an order performed on it before (there's a lot of FLOC that weren't maintained before)
    -- fact_work_order.RowNum = 1
ORDER BY floc, work_order_basic_finish_date