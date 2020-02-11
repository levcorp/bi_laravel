((SELECT
	 (100 - t1."DpmPrcnt") AS anticipo,
	 t0."TaxCode",
	 t1."DocType",
	 t7."Code" AS periodo,
	 t1."U_BF_SUCURSAL" AS sucursal,
	 
		LEFT(t7."Code",
	 4) AS "AÑO",
	 
		LEFT(MonthName(t1."DocDate"),
	 3) AS mes,
	 (CASE WHEN 
			RIGHT(QUARTER(T1."DocDate",
	 2),
	 1) = 1 
			THEN 4 WHEN 
			RIGHT(QUARTER(T1."DocDate",
	 2),
	 1) = 2 
			THEN 1 WHEN 
			RIGHT(QUARTER(T1."DocDate",
	 2),
	 1) = 3 
			THEN 2 WHEN 
			RIGHT(QUARTER(T1."DocDate",
	 2),
	 1) = 4 
			THEN 3 
			ELSE 0 
			END) AS q,
	 WEEK(t1."DocDate") AS sem,
	 t1."DocDate" AS fecha,
	 t1."DocNum" AS nfac_sap,
	 t8."CardCode" AS cod_cliente,
	 t8."CardName" AS nombre_cliente,
	 t8."LicTradNum" AS nit,
	 (CASE t1."DocType" WHEN 'S' 
			THEN 'servicio' 
			ELSE t3."FirmName" 
			END) AS nombre_fabricante,
	 t0."Quantity" AS cantidad,
	 t0."PriceAfVAT" AS precio_con_iva,
	 t0."Dscription" AS descricion,
	 t2."U_Cod_Vent" AS cod_ventas,
	 t2."U_Cod_comp" AS cod_comp,
	 TO_DECIMAL( (CASE WHEN t1."DpmAmnt" = 0 
				THEN ( CASE t1."DocType" WHEN 'S' 
					THEN (CASE t0."Currency" WHEN 'BS' 
						THEN t0."PriceAfVAT" / (t1."DocTotalSy" / t1."DocTotal") WHEN 'USD' 
						THEN t0."PriceAfVAT" 
						ELSE t0."PriceAfVAT" 
						END) 
					ELSE (CASE t0."Currency" WHEN 'BS' 
						THEN t0."PriceAfVAT" / (t1."DocTotalSy" / t1."DocTotal") WHEN 'USD' 
						THEN t0."PriceAfVAT" 
						ELSE t0."PriceAfVAT" 
						END) * t0."Quantity" 
					END) * ((100 - ifnull(ifnull(t1."DiscPrcnt",
	 0),
	 0)) / 100) WHEN t1."DpmAmnt" IS NULL 
				THEN (CASE t1."DocType" WHEN 'S' 
					THEN (CASE t0."Currency" WHEN 'BS' 
						THEN t0."PriceAfVAT" / (t1."DocTotalSy" / t1."DocTotal") WHEN 'USD' 
						THEN t0."PriceAfVAT" 
						ELSE t0."PriceAfVAT" 
						END) 
					ELSE (CASE t0."Currency" WHEN 'BS' 
						THEN t0."PriceAfVAT" / (t1."DocTotalSy" / t1."DocTotal") WHEN 'USD' 
						THEN t0."PriceAfVAT" 
						ELSE t0."PriceAfVAT" 
						END) * t0."Quantity" 
					END) * ((100 - ifnull(t1."DiscPrcnt",
	 0)) / 100) 
				ELSE (CASE t1."DocType" WHEN 'S' 
					THEN (CASE t0."Currency" WHEN 'BS' 
						THEN t0."PriceAfVAT" / (t1."DocTotalSy" / t1."DocTotal") WHEN 'USD' 
						THEN t0."PriceAfVAT" 
						ELSE t0."PriceAfVAT" 
						END) 
					ELSE (CASE t0."Currency" WHEN 'BS' 
						THEN t0."PriceAfVAT" / (t1."DocTotalSy" / t1."DocTotal") WHEN 'USD' 
						THEN t0."PriceAfVAT" 
						ELSE t0."PriceAfVAT" 
						END) * t0."Quantity" 
					END) * ((100 - ifnull(t1."DiscPrcnt",
	 0)) / 100) * ((t1."DocTotal") / (t1."DocTotal" + t1."DpmAmnt" / 0.87)) 
				END),
	 21,
	 6 ) total_USD,
	 t0."Currency" AS moneda,
	 t9."SlpName" AS vendedor,
	 t1."U_NUM_FACT" AS fact,
	 (CASE WHEN t1."isIns" = 'N' 
			THEN 'normal' 
			ELSE 'reservada' 
			END) AS tipo_fact,
	 t0."ItemCode" AS codigo_sap,
	 t10."GroupName" grupo,
	 t1."U_RAZSOC" razon_social,
	 t2."U_Codigo_BR" AS brand,
	 (CASE WHEN t2."U_Cod_SUB_BR" IS NULL 
			THEN '-' 
			ELSE t2."U_Cod_SUB_BR" 
			END) AS sub_brand,
	 (CASE WHEN t8."U_Codigo_IM" IS NULL 
			THEN 'sin asignar' 
			ELSE t8."U_Codigo_IM" 
			END) AS industry,
	 t1."U_SERVICIO",
	 t0."BaseRef",
	 t11."Name",
	 t4."SlpCode",
	 (CASE WHEN t2."SuppCatNum" IS NOT NULL 
			THEN t2."SuppCatNum" 
			ELSE t3."FirmName" 
			END) AS nombre_fabricante1,
	 t1."U_Num_Cot",
	 CASE WHEN t2."QryGroup1" = 'Y' 
		THEN 'PDI' WHEN t2."QryGroup2" = 'Y' 
		THEN 'Campaña' WHEN t2."QryGroup4" = 'Y' 
		THEN 'Liquidacion' 
		ELSE 'otro' 
		END AS programa_gc,
	 t0."StockPrice" AS c_unitario,
	 t1."PaidToDate" pagado,
	 (CASE WHEN t1."U_zona_comex" IS NULL 
			THEN (CASE WHEN t8."U_Codigo_IM" IS NULL 
				THEN 'sin asignar' 
				ELSE t8."U_Codigo_IM" 
				END) 
			ELSE t1."U_zona_comex" 
			END) AS sector,
	 (CASE WHEN t1."ShipToCode" IS NULL 
			THEN t1."CardName" WHEN t1."ShipToCode" = ' ' 
			THEN t1."CardName" 
			ELSE t1."ShipToCode" 
			END) planta,
	 t12."PymntGroup" credito,
	 t2."QryGroup60" AS Liquidacion ,
	 (Case T1."U_Tipo_OV" When 'Capex' 
			Then 'GAP' When 'Opex' 
			Then 'FLUJO' When 'GAP2' 
			Then 'CAMPAÑA' 
			Else '' 
			End) AS Tipo_OV,
	 t4."Email",
	 T2."U_FAMILIA" "FAMILIA",
	 T2."U_SUBFAMILIA" "SUBFAMILIA",
	 t0."BaseEntry" ,
	 t1."U_Num_OV" ,
	 
		FROM oinv AS t1 
		INNER JOIN INV1 t0 ON t0."DocEntry" = t1."DocEntry" 
		LEFT OUTER JOIN OITM t2 ON t0."ItemCode" = t2."ItemCode" 
		LEFT OUTER JOIN OMRC t3 ON t2."FirmCode" = t3."FirmCode" 
		INNER JOIN OSLP t4 ON t1."SlpCode" = t4."SlpCode" 
		LEFT OUTER JOIN OITB t5 ON t2."ItmsGrpCod" = t5."ItmsGrpCod" 
		INNER JOIN NNM1 t6 ON t1."Series" = t6."Series" 
		INNER JOIN OFPR t7 ON t1."FinncPriod" = t7."AbsEntry" 
		INNER JOIN OCRD t8 ON t1."CardCode" = t8."CardCode" 
		INNER JOIN OSLP t9 ON t9."SlpCode" = t1."SlpCode" 
		INNER JOIN OCRG t10 ON t8."GroupCode" = t10."GroupCode" 
		LEFT OUTER JOIN OCPR t11 ON t1."CntctCode" = t11."CntctCode" 
		INNER JOIN OCTG t12 ON t8."GroupNum" = t12."GroupNum" 
		WHERE t0."TargetType" <> 14 
		AND t1."DocTotal" <> 0 
		and (t2."QryGroup64" like 'N' 
			or t1."DocType"='S')) 
			
		
	UNION ALL (SELECT
	 t1."DpmPrcnt" AS anticipo,
	 t0."TaxCode",
	 t1."DocType",
	 t7."Code" AS periodo,
	 t1."U_BF_SUCURSAL" AS sucursal,
	 
		LEFT(t7."Code",
	 4) AS "AÑO",
	 
		LEFT(MonthName(t1."DocDate"),
	 3) AS mes,
	 (CASE WHEN 
			RIGHT(QUARTER(T1."DocDate",
	 2),
	 1) = 1 
			THEN 4 WHEN 
			RIGHT(QUARTER(T1."DocDate",
	 2),
	 1) = 2 
			THEN 1 WHEN 
			RIGHT(QUARTER(T1."DocDate",
	 2),
	 1) = 3 
			THEN 2 WHEN 
			RIGHT(QUARTER(T1."DocDate",
	 2),
	 1) = 4 
			THEN 3 
			ELSE 0 
			END) AS q,
	 WEEK(t1."DocDate") AS sem,
	 t1."DocDate" AS fecha,
	 t1."DocNum" AS nfac_sap,
	 t8."CardCode" AS cod_cliente,
	 t8."CardName" AS nombre_cliente,
	 t8."LicTradNum" AS nit,
	 (CASE t1."DocType" WHEN 'S' 
			THEN 'servicio' 
			ELSE t3."FirmName" 
			END) AS nombre_fabricante,
	 t0."Quantity" AS cantidad,
	 t0."PriceAfVAT" AS precio_con_iva,
	 t0."Dscription" AS descricion,
	 t2."U_Cod_Vent" AS cod_ventas,
	 t2."U_Cod_comp" AS cod_comp,
	 TO_DECIMAL( (CASE t1."DocType" WHEN 'S' 
				THEN ((CASE T0."Currency" WHEN 'BS' 
						THEN t0."PriceAfVAT"/(T1."DocTotalSy"/T1."DocTotal") WHEN 'USD' 
						THEN t0."PriceAfVAT" 
						ELSE t0."PriceAfVAT" 
						END) * t1."DpmPrcnt" / 100) 
				ELSE ((CASE T0."Currency" WHEN 'BS' 
						THEN t0."PriceAfVAT"/(T1."DocTotalSy"/T1."DocTotal") WHEN 'USD' 
						THEN t0."PriceAfVAT" 
						ELSE t0."PriceAfVAT" 
						END)*T0."Quantity"*t1."DpmPrcnt" / 100) 
				END),
	 21,
	 6) total_USD,
	 T0."Currency" AS Moneda,
	 t9."SlpName" AS Vendedor,
	 T1."U_NUM_FACT" AS fact,
	 'Anticipada' AS Tipo_Fact,
	 T0."ItemCode" AS codigo_sap,
	 T10."GroupName" Grupo,
	 T1."U_RAZSOC" Razon_Social,
	 T2."U_Codigo_BR" AS Brand,
	 (CASE WHEN T2."U_Cod_SUB_BR" IS NULL 
			THEN '-' 
			ELSE T2."U_Cod_SUB_BR" 
			END) AS Sub_Brand,
	 (CASE WHEN t8."U_Codigo_IM" IS NULL 
			THEN 'Sin Asignar' 
			ELSE t8."U_Codigo_IM" 
			END) AS Industry,
	 T1."U_SERVICIO",
	 T0."BaseRef",
	 T11."Name",
	 T4."SlpCode",
	 (CASE WHEN t2."SuppCatNum" IS NOT NULL 
			THEN t2."SuppCatNum" 
			ELSE t3."FirmName" 
			END) AS Nombre_Fabricante1,
	 T1."U_Num_Cot",
	 CASE WHEN t2."QryGroup1" = 'Y' 
		THEN 'PDI' WHEN t2."QryGroup2" = 'Y' 
		THEN 'CAMPAÑA' WHEN t2."QryGroup4" = 'Y' 
		THEN 'Liquidacion' 
		ELSE 'otro' 
		END AS PROGRAMA_GC,
	 T0."StockPrice",
	 T1."PaidToDate" Pagado,
	 (CASE WHEN T1."U_zona_comex" IS NULL 
			THEN (CASE WHEN t8."U_Codigo_IM" IS NULL 
				THEN 'Sin Asignar' 
				ELSE t8."U_Codigo_IM" 
				END) 
			ELSE T1."U_zona_comex" 
			END) AS Sector,
	 (CASE WHEN t1."ShipToCode" IS NULL 
			THEN t1."CardName" WHEN t1."ShipToCode" = ' ' 
			THEN t1."CardName" 
			ELSE t1."ShipToCode" 
			END) AS Planta,
	 T12."PymntGroup",
	 t2."QryGroup60" AS Liquidacion,
	 (Case T1."U_Tipo_OV" When 'Capex' 
			Then 'GAP' When 'Opex' 
			Then 'FLUJO' When 'GAP2' 
			Then 'CAMPAÑA' 
			Else '' 
			End) AS Tipo_OV ,
	 t4."Email",
	 T2."U_FAMILIA" "FAMILIA",
	 T2."U_SUBFAMILIA" "SUBFAMILIA",
	 0 ,
	 t1."U_Num_OV" 
		FROM ODPI AS T1 
		INNER JOIN DPI1 T0 ON T0."DocEntry" = T1."DocEntry" 
		LEFT OUTER JOIN OITM T2 ON T0."ItemCode" = T2."ItemCode" 
		LEFT OUTER JOIN OMRC T3 ON T2."FirmCode" = T3."FirmCode" 
		INNER JOIN OSLP T4 ON T1."SlpCode" = T4."SlpCode" 
		LEFT OUTER JOIN OITB T5 ON T2."ItmsGrpCod" = T5."ItmsGrpCod" 
		INNER JOIN NNM1 T6 ON T1."Series" = T6."Series" 
		INNER JOIN OFPR T7 ON T1."FinncPriod" = T7."AbsEntry" 
		INNER JOIN OCRD t8 ON T1."CardCode" = t8."CardCode" 
		INNER JOIN Oslp t9 ON T9."SlpCode" = t1."SlpCode" 
		INNER JOIN OCRG T10 ON T8."GroupCode" = T10."GroupCode" 
		LEFT OUTER JOIN OCPR T11 ON T1."CntctCode" = T11."CntctCode" 
		INNER JOIN OCTG T12 ON T8."GroupNum" = T12."GroupNum" 
		WHERE T0."TargetType" <> 14 
		AND t1."DocTotal" <> 0 
		and (t2."QryGroup64" like 'N' 
			or t1."DocType"='S'))) 
		