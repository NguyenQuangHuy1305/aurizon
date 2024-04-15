SELECT TOP (1000) [WO_AUFNR_OrderInternalKey]
      ,[WO_AUFNR_Order]
      ,[WO_IPHAS_StatusOutstandingFlag]
      ,[WO_IPHAS_StatusInProcessFlag]
      ,[WO_IPHAS_StatusCompletedFlag]
      ,[WO_IPHAS_StatusDeletedFlag]
      ,[WO_KTEXT_OrderDescr]
      ,[WO_AUART_OrderType]
      ,[WO_ORDTYP_TXT_OrderTypeDescr]
      ,[WO_AUTYP_OrderCategory]
      ,[WO_BUKRS_CompanyCode]
      ,[WO_ERDAT_CreatedDate]
      ,[WO_ARBPL_WorkCenter]
      ,[WO_INGPR_PlannerGroup]
      ,[WO_ILART_MaintenanceActivityType]
      ,[WO_ILATX_MaintenanceActivityTypeDescr]
      ,[WO_SWERK_Plant]
      ,[WO_IWERK_PlanningPlant]
      ,[WO_EQUNR_Equipment]
      ,[WO_STRNO_FunctionalLocation]
      ,[WO_QMNUM_Notification]
      ,[WO_KOKRS_ControllingArea]
      ,[WO_KOSTV_ResponsibleCostCenter]
      ,[WO_KOSTL_AccountCostCenter]
      ,[WO_PLNTY_TaskListType]
      ,[WO_PLNNR_TaskListGroup]
      ,[WO_PLNAL_TaskListGroupCounter]
      ,[WO_KTEXT_TaskListDescr]
      ,[WO_SOWRK_LocationPlant]
      ,[WO_STORT_Location]
      ,[WO_KTEXT_LocationDescr]
      ,[WO_PSPNR_EXT_WBSElement]
      ,[WO_POST1_WBSElementDescr]
      ,[WO_POSKI_Project]
      ,[WO_POST1_ProjectDescr]
      ,[WO_FUNC_AREA_FunctionalArea]
      ,[WO_PRCTR_ProfitCenter]
      ,[WO_GSTRP_BasicStartDate]
      ,[WO_GLTRP_BasicFinishDate]
      ,[WO_GSTRS_ScheduledStartDate]
      ,[WO_GLTRS_ScheduledFinishDate]
      ,[WO_IDAT2_TechCompletionDate]
      ,[WO_ZZ_COMPLIANCE_DT_ComplianceDate]
      ,[WO_ZZ_COMPL_NPLDA_ComplianceNextPlannedDate]
      ,[WO_ZZ_NOTIF_MODID_Modification]
      ,[WO_ZZ_RESPONSIBLE_ResponsiblePerson]
      ,[WO_ZZ_REQUESTEDBY_RequestedBy]
      ,[WO_WARPL_MaintenancePlan]
      ,[WO_WPTXT_MaintenancePlanDescr]
      ,[WO_WAPOS_MaintenanceItem]
      ,[WO_PSTXT_MaintenanceItemDescr]
      ,[WO_ABNUM_MaintenancePlanCallNumber]
      ,[WO_PARNR_ResponisblePersonNumber]
      ,[WO_ENAME_ResponisblePersonName]
      ,[WO_PLTXT_FunctionalLocationDescr]
      ,[WO_FLTYP_FunctionalLocationCategory]
      ,[WO_TYPTX_FunctionalLocationCategoryDescr]
      ,[WO_EQART_FunctionalLocationTechnicalObjectType]
      ,[WO_EARTX_FunctionalLocationTechnicalObjectTypeDescr]
      ,[WO_EQKTX_EquipmentDescr]
      ,[WO_EQTYP_EquipmentCategory]
      ,[WO_TYPTX_EquipmentCategoryDescr]
      ,[WO_EQART_EquipmentTechnicalObjectType]
      ,[WO_EARTX_EquipmentTechnicalObjectTypeDescr]
      ,[WO_REVNR_Revision]
      ,[WO_LastUpdatedDate]
      ,[WO_MechProdOrderTypeFlag]
  FROM [myANALYTICS_SP].[silver.dimension.enterprise.asset].[vw_Dim_WorkOrder]

  where [WO_AUFNR_Order] = '80116441'
