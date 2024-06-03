WITH NOTIF AS (
	SELECT DISTINCT
		NOTIF.[NOTIF_ZZQMMODID_NotificationModificationId],
		CHL.[CLINT_ClassNumberInternalKey],
		CHL.[KLART_ClassTypeID],
		CONCAT(CHL.[QMNUM_NotificationInternalKey],CHL.[FENUM_NotificationItemKey]) AS OBJEK,
		CHL.[LRPID_LinearReferencePatternID],
		NOTIF.[NOTIF_QMNUM_Notification],
		NOTIF.[NOTIF_QMART_NotificationType],
		STM.ThroughMetre AS StartTM,
		ETM.ThroughMetre AS EndTM
	-- notif characteristics. 
	FROM [myANALYTICS_SP].[gold.fact.enterprise.asset].[vw_Fact_NotificationCharacteristicWithLinear] AS CHL
	-- this is an inner join in the HANA query. However that was on SPM only view. This view has everything. I'm not really sure what the limitations of the HANA view are to be SPM only. So I haven't limited this one. 
	INNER JOIN [myANALYTICS_SP].[gold.dimension.enterprise.asset].[vw_Dim_Notification] AS NOTIF ON CHL.[QMNUM_NotificationInternalKey] = NOTIF.[NOTIF_QMNUM_NotificationInternalKey]
	-- these convert the KM data to Start and End through meters. These are then used in the final part of the query to return the SPM data. 
	CROSS APPLY [config.enterprise.geospatial].[tf_KilometreToThroughMetre] ([LRPID_LinearReferencePatternID], FLOOR([START_POINT_LinearStartPointKM]), ([START_POINT_LinearStartPointKM]- FLOOR([START_POINT_LinearStartPointKM]))*1000) STM
	CROSS APPLY [config.enterprise.geospatial].[tf_KilometreToThroughMetre] ([LRPID_LinearReferencePatternID], FLOOR([END_POINT_LinearEndPointKM]), ([END_POINT_LinearEndPointKM]- FLOOR([END_POINT_LinearEndPointKM]))*1000) ETM
	WHERE 
		CHL.[KLART_ClassTypeID] = '015' 
		AND CHL.[CLINT_ClassNumberInternalKey] = '0000001726' 
		AND NOTIF.[NOTIF_QMART_NotificationType] = 'N4' 
		-- you do not need to filter on POSNR because the values are returned in columns below. 
)

SELECT NOTIF.*
-- These are the POSNR values as columns 
    ,SPM.ID
	,SPM.ScopePushed
	,SPM.AssetClass
	,SPM.Program
	,SPM.SAPWBSNumber
	,SPM.ScopeSubset
	,SPM.ScopeQuantity
	,SPM.LSC
	,SPM.StartStation
	,SPM.EndStation
	,SPM.Road
	,SPM.FARID
	,SPM.Rail
	,SPM.FYEstimate
	,SPM.CriticalitySingleTrack
	,SPM.CriticalityTotalTrack
	,SPM.CRA
	,SPM.BaselineDate
	,SPM.CommissioningDate
	,SPM.ExpectedReplacementDate
	,SPM.DesignLife
	,SPM.CostofReplacement
	,SPM.LastInspectionCondition
	,SPM.LastInspectionDate
	,SPM.Program2
	,SPM.RIGSubmissionDate
	,SPM.LatestRenewalDate
	,SPM.RIGTableCategory
	,SPM.SleeperQuantity
	,SPM.RailQuantity
	,SPM.TrackKM
	,SPM.RailKM 
	,SPM.StartThroughmetre
	,SPM.EndThroughmetre
FROM NOTIF
CROSS APPLY [gold.belowrail.asset.track.ringfenced].[tf_ScopePriorityModel] ([LRPID_LinearReferencePatternID], StartTM, EndTM) SPM
-- filtering to 2024
--WHERE SPM.FinancialYear = '2024'