import pandas as pd
import pyodbc
from datetime import datetime

sql_query = """
    -- all WO and their flocid
    SELECT
        [WorkOrderNumber],
        [OrderType],
        [CompanyCode],
        [FunctionLocation],
        CASE
            WHEN [TechCompletionDate] IS NULL THEN [BasicFinishDate]
            ELSE [TechCompletionDate]
        END AS 'CompletionDate',
        [MaintenanceActivityType],
        [MaintenanceActivityTypeDesc],
        [MainUserStatus],
        [MainUserStatusDesc],
        [ActualTotalCost]
    FROM [myANALYTICS_SP].[bronze.batch.belowrail.asset.ringfenced].[vw_WorkOrder]
    WHERE
        [MaintenanceActivityType] IN
            (
                'C01', 'C14', 'C20', 'C02', 'C13', 'C03', 'C19', 'C23', 'C25', 'C26', 'C10', -- Mechanised Track Maintenance
                'C29', 'C31', 'T31', 'C37', 'C08', 'C47', 'C54', 'C43', 'C51', 'C53', 'C57', 'C70', 'C72', 'C50', 'C10', 'C30', 'C48', 'C54', 'C52', 'C06', 'C07', 'C44', 'C01', 'C41', -- General Track Maintenance
                'B50', 'B53', 'C67', 'B04', 'B05', 'B06', 'B55', 'B57', -- Structures Maintenance
                'T28', 'T29', 'T33', 'T40', 'T41', 'T58', 'T44', 'T45', 'T34', 'T46', 'T47', 'T48', 'T54', 'T42', 'T43', -- Control Systems - Signalling and Wayside Maintenance
                'T10', 'T11', 'T32', -- Control Systems - Telecommunications Maintenance
                'C54', 'T32', -- Control Systems - Operational Systems Maintenance
                'T26', 'T27', 'T32', 'T24', 'T25', 'E31' -- Traction Power Maintenance
            )
        AND [CompanyCode] = '5000'
        AND [MainUserStatusDesc] = 'Practically Completed'
        AND [ActualTotalCost] IS NOT NULL
        AND [ActualTotalCost] > 0
        AND OrderType <> 'MW04'
"""

# Define your server name
server_name = 'myanalytics.aurizon.com.au'

# Establish a connection using Windows Authentication
conn = pyodbc.connect('DRIVER={SQL Server};SERVER=' + server_name + ';DATABASE=myANALYTICS_SP;Trusted_Connection=yes;')

# Execute the SQL query and load the result into a pandas DataFrame
all_maint_wo = pd.read_sql_query(sql_query, conn)


# Getting all FLOC from [vw_Dim_FunctionalLocation] where CompanyCode = 5000 -> df2_no_length
sql_query2 = """
    SELECT
        FLOC_STRNO_FunctionalLocation,
        FLOC_PLTXT_FunctionalLocationDescr,
        FLOC_EARTX_TechnicalObjectTypeDescr,
        FLOC_STORT_LocationDescr
    FROM [myANALYTICS_SP].[silver.dimension.enterprise.asset].[vw_Dim_FunctionalLocation]
	WHERE
        FLOC_BUKRS_CompanyCode = '5000'
"""

# Define your server name
server_name = 'myanalytics.aurizon.com.au'

# Establish a connection using Windows Authentication
conn = pyodbc.connect('DRIVER={SQL Server};SERVER=' + server_name + ';Trusted_Connection=yes;')

# Execute the SQL query and load the result into a pandas DataFrame
all_floc = pd.read_sql_query(sql_query2, conn)

# all_maint_type_df = pd.DataFrame(df2['FLOC_EARTX_TechnicalObjectTypeDescr'].unique(), columns=['FLOC_EARTX_TechnicalObjectTypeDescr'])