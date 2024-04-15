SELECT TOP (1000) 
       [ILART_ActivityTypeProductID]
      ,[CHAR5_MechProdReportTypeID]
	  ,COUNT(*)
  FROM [myANALYTICS_SP].[silver.fact.belowrail.asset].[vw_Fact_MechProdOperation]
  GROUP BY
	[ILART_ActivityTypeProductID]
      ,[CHAR5_MechProdReportTypeID]
[silver.dimension.enterprise.asset].[vw_Dim_MaintenanceActivityType]