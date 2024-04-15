WITH df1 AS (
    SELECT
        *,
        -- Creating [Asset Type Rail] column
        LOWER(COALESCE(LEFT_RAIL_MASS, '') + ' Rail - ') +
        CASE WHEN LEFT_RAIL_HARDNESS LIKE '%HH%' THEN LEFT_RAIL_HARDNESS + ' ' ELSE '' END +
        CASE WHEN [Class] = 'CURVE' THEN 'Curves' ELSE 'Straights' END +
        CASE
            WHEN TRY_CONVERT(FLOAT, RADIUS_OF_CURVE) IS NULL THEN ''
            WHEN TRY_CONVERT(FLOAT, RADIUS_OF_CURVE) >= 1001 THEN ' (1001 to 2500 metre radius)'
            WHEN TRY_CONVERT(FLOAT, RADIUS_OF_CURVE) >= 601 THEN ' (601 to 1000 metre radius)'
            ELSE ' (200 to 600 metre radius)'
        END AS [Asset Type Rail],

        -- Creating [Asset Type Sleepers] column
        CASE
            WHEN SLEEPER_SIZE_VALUE = 'CON 28T' THEN '28.0 Tonne Axle Load PSC Sleepers'
            WHEN SLEEPER_SIZE_VALUE = 'CON 22T' THEN '22.5 Tonne Axle Load PSC Sleepers'
            WHEN SLEEPER_SIZE_VALUE IN ('INTERSPERSED CONCRETE/TIMBER', 'TIMBER') THEN 'Timber Sleepers'
            WHEN SLEEPER_SIZE_VALUE = 'STEEL' THEN 'Steel Sleepers'
            ELSE NULL
        END AS [Asset Type Sleepers],

        -- Creating [Asset Type Fastenings] column
        CASE
            WHEN SLEEPER_FASTENINGS IS NULL THEN SLEEPER_FASTENINGS
            WHEN SLEEPER_FASTENINGS LIKE '%PANDROL%' THEN 'Replace Pandrol E-Clip Fastenings'
            WHEN SLEEPER_FASTENINGS = 'FIST-BTR' THEN 'Replace Fist Fastenings'
            ELSE SLEEPER_FASTENINGS
        END AS [Asset Type Fastenings]
    FROM [myANALYTICS_SP].[bronze.batch.belowrail.asset.track.ringfenced].[vw_FLOCTrackFeature]
),
df2 AS (
    SELECT
        *,
        -- Creating [Asset Type Points and Crossing] column
        LOWER(COALESCE(ANGLE, '') + ' (' + COALESCE(LEFT_RAIL_MASS, '') + ') ') +
        CASE
            WHEN VEE_TYPE IS NULL THEN NULL
            WHEN VEE_TYPE = 'SWINGNOSE' THEN 'Swing Nose Points and Crossing'
            WHEN VEE_TYPE = 'RBM' THEN 'RBM Points and Crossing'
            WHEN VEE_TYPE = 'FABRICATED' THEN 'Fabricated Points and Crossing'
            WHEN VEE_TYPE = 'SPRINGWING' THEN 'Spring Wing Crossing'
            ELSE VEE_TYPE
        END AS [Asset Type Points and Crossing]
    FROM [myANALYTICS_SP].[bronze.batch.belowrail.asset.track.rail.ringfenced].[vw_FLOCTurnoutExtended]
),
irj AS (
    SELECT
        *,
        CASE
            WHEN UserStatusDesc IS NULL THEN NULL
            ELSE 'Insulated Rail Joints'
        END AS [Asset Type IRJs]
    FROM [myANALYTICS_SP].[bronze.batch.belowrail.asset.track.rail.ringfenced].[vw_FLOCIRJ]
)

SELECT
    *,
    
FROM (
    SELECT
        FuncLocID,
        [Asset Type Rail],
        [Asset Type Sleepers],
        [Asset Type Fastenings],
        NULL AS [Asset Type Points and Crossing],
        NULL AS [Asset Type IRJs],
        FuncLocLinearLengthKM
    FROM df1
    UNION ALL
    SELECT
        FuncLocID,
        NULL AS [Asset Type Rail],
        NULL AS [Asset Type Sleepers],
        NULL AS [Asset Type Fastenings],
        [Asset Type Points and Crossing],
        NULL AS [Asset Type IRJs],
        FuncLocLinearLengthKM
    FROM df2
    UNION ALL
    SELECT
        FuncLocID,
        NULL AS [Asset Type Rail],
        NULL AS [Asset Type Sleepers],
        NULL AS [Asset Type Fastenings],
        NULL AS [Asset Type Points and Crossing],
        [Asset Type IRJs],
        FuncLocLinearLengthKM
    FROM irj
) AS test1