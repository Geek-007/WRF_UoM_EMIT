;  NCL module for storing hard coded data 
;  needed during the processing of emissions.
;
;  Once this file gets too long then split into
;  separate themed files.

load "./scheme_mozm_vbs4_pnnl_data.ncl"
load "./scheme_cbmz_mos_htap_data.ncl"
load "./scheme_cri_mos_edgar_htap_data.ncl"
load "./scheme_nmvoc_data.ncl"

;*********************************************
begin

;;;;; define which variables we are going to be reading in for processing
	
	
	;;; list the emission categories we will be using
	emiss_cat = (/"CO","NOx","SO2","NMVOC","BC","OC","PM2_5","PM10","NH3","OC_DOM","OC_TRA"/)
	;;; some of the categories are "sub"categories, so list the parent categories for each
	emiss_orig= (/"CO","NOx","SO2","NMVOC","BC","OC","PM2_5","PM10","NH3","OC","OC"/)

	;;; give our indexes for the emission categories (for when we've an emission database)
	emiss_cat_index = True
	emiss_cat_index@CO  	= 0
	emiss_cat_index@NOx 	= 1
    emiss_cat_index@SO2 	= 2
    emiss_cat_index@NMVOC	= 3
    emiss_cat_index@BC		= 4
    emiss_cat_index@OC		= 5
    emiss_cat_index@PM2_5	= 6
    emiss_cat_index@PM10	= 7
    emiss_cat_index@NH3		= 8
    ;;; note how many original variables there are,
    ;;;  this index will be used to limit our initial processing of the variables
    number_original_emission_variables = 9

	;;; these are the indexes for "child" variables, which are subsets of the original emission
	;;; variables
    emiss_cat_index@OC_DOM  = 9
    emiss_cat_index@OC_TRA  = 10

	;;;; define the sector indexes for each variable
	emiss_cat@CO    = (/"POW","IND","RES","TRA","SHP"/)
	emiss_cat@NOx   = (/"POW","IND","RES","TRA","SHP"/)
	emiss_cat@SO2   = (/"POW","IND","RES","TRA","SHP"/)
	emiss_cat@NMVOC = (/"POW","IND","RES","TRA","SHP"/)
	emiss_cat@BC    = (/"POW","IND","RES","TRA","SHP"/)
	emiss_cat@OC    = (/"POW","IND","RES","TRA","SHP"/)
	emiss_cat@PM2_5 = (/"POW","IND","RES","TRA","SHP"/)
	emiss_cat@PM10  = (/"POW","IND","RES","TRA","SHP"/)
	emiss_cat@NH3   = (/"IND","RES","TRA","AGR"/)
	; Definitions for DOM (domestic) and TRA (traffic) are taken from our original speciation for the RONOCO work
	;           In the long term we need to think about how we want to split these (especially when we're working
	;           with the individual VBS emission groups)
	emiss_cat@OC_DOM= (/"RES"/)
	emiss_cat@OC_TRA= (/"POW","IND","TRA","SHP"/)

	;;; list the emission sectors we will be working with
	emiss_sector = (/"POW","IND","RES","TRA","AGR","SHP","SLV"/)

	;;; give our indexes for the emission sectors
	emiss_sector_index = True
	emiss_sector_index@POW = 0    ; power
	emiss_sector_index@IND = 1    ; industry
	emiss_sector_index@RES = 2    ; residential
	emiss_sector_index@TRA = 3    ; traffic
	emiss_sector_index@AGR = 4    ; agriculture
	emiss_sector_index@SHP = 5    ; shipping
	emiss_sector_index@SLV = 6    ; solvents

;;;;; diurnal cycle information

	; Define diurnal variations for sector, normalised to avg=1.0,
	; Set for timezone UTC(0)  (starting at 0000 hours, not 0100 hours)
	;  
	; Diurnal cycles taken from:
	;         Olivier, J., J. Peters, C. Granier, G. Pétron, J.F. Müller, and S. Wallens, 
	;         Present and future surface emissions of atmospheric compounds, POET Report #2, 
	;         EU project EVK2-1999-00011, 2003. 
	;
	diurnal_cycles = True 
	
	diurnal_cycles@POW = (/0.925,0.839,0.755,0.713,0.707,0.717,0.765, \
						0.859,1.001,1.136,1.207,1.221,1.217, \
						1.195,1.160,1.141,1.131,1.109,1.081, \
						1.056,1.030,1.022,1.018,0.993/)

	diurnal_cycles@IND = (/0.762,0.743,0.740,0.754,0.795,0.853,0.918, \
						0.985,1.056,1.130,1.198,1.252,1.291, \
						1.262,1.231,1.244,1.209,1.126,1.046, \
						0.976,0.922,0.877,0.832,0.797/)

	diurnal_cycles@RES = (/0.701,0.389,0.348,0.341,0.345,0.345,0.419, \
						0.838,1.356,1.549,1.565,1.459,1.257, \
						1.109,1.061,1.026,0.985,1.021,1.092, \
						1.282,1.503,1.470,1.369,1.170/)

	diurnal_cycles@SLV = (/0.499,0.449,0.379,0.356,0.372,0.427,0.563, \
						0.820,1.178,1.392,1.405,1.424,1.459, \
						1.482,1.506,1.520,1.512,1.510,1.459, \
						1.258,1.000,0.826,0.668,0.536/)

	diurnal_cycles@TRA = (/0.43,0.18,0.08,0.05,0.04,0.08, \
						0.22,0.87,1.85,1.85,1.41,1.25, \
						1.20,1.31,1.44,1.44,1.60,2.04, \
						2.09,1.51,1.07,0.75,0.63,0.61/)


	diurnal_cycles@AGR = (/0.6,0.6,0.6,0.6,0.6,0.6, \
						0.65,0.75,0.90,1.10,1.25,1.44, \
						1.59,1.79,1.74,1.69,1.55,1.35, \
						1.10,0.9,0.75,0.65,0.6,0.6/)

	diurnal_cycles@SHP = (/1.0,1.0,1.0,1.0,1.0,1.0, \
						1.0,1.0,1.0,1.0,1.0,1.0, \
						1.0,1.0,1.0,1.0,1.0,1.0, \
						1.0,1.0,1.0,1.0,1.0,1.0/)

	;;; We only have data on the hour here - but this will be interpolated
	;;;   within the scripts for countries which shift their timezones by 30 minutes


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; NMVOC schemes setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

available_nmvoc_schemes = "EDGAR MACCITY"   ; this is be a single string, space delimited, listing all the available schemes





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; OUTPUT schemes setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

available_schemes = "mozm_vbs4_pnnl cbmz_mos_htap cri_mos_edgar_htap"   ; this is be a single string, space delimited, listing all the available schemes

;;; These lists of variables for each scheme
;;;    are used for creating the empty output files.
variable_lists = True
variable_lists@GAS_mozm_vbs4_pnnl = (/"E_CO", "E_NO", "E_NO2",  "E_SO2", "E_NH3",  "E_HONO", "E_SULF"/)
variable_lists@NMVOC_mozm_vbs4_pnnl = (/"E_BIGALK", "E_BIGENE", "E_C2H4", "E_C2H5OH", "E_C2H6", "E_C3H6", "E_C3H8",  \
   										"E_CH2O", "E_CH3CHO", "E_ISOP", "E_CH3COCH3", "E_CH3OH", "E_MEK", \
   										"E_TOLUENE", "E_BENZENE", "E_XYLENE", "E_C10H16", "E_C2H2", "E_GLY", \
   										"E_MACR", "E_MGLY", "E_MVK", "E_HCOOH", "E_CH3COOH" /)
variable_lists@AERO_mozm_vbs4_pnnl = (/"E_PM25J", "E_PM_10", "E_NO3J", "E_NO3C", "E_SO4J","E_SO4C", \
										"E_ECJ", "E_ECC", "E_ORGJ", "E_ORGC", "E_CO_A", "E_CO_BB" /)

; settings for "cbmz_mos_htap" (emiss_opt==25)
variable_lists@GAS_cbmz_mos_htap = (/"E_CO", "E_NO", "E_NO2",  "E_SO2", "E_NH3"/)
variable_lists@NMVOC_cbmz_mos_htap = (/"E_PAR","E_ISO","E_ETH","E_HC3","E_HC5","E_HC8","E_XYL", \
										"E_OL2","E_OLT","E_OLI","E_TOL","E_CSL","E_HCHO", \
										"E_ALD","E_KET","E_ORA2","E_CH3OH","E_C2H5OH", "E_C2H4" /)
variable_lists@AERO_cbmz_mos_htap = (/"E_BC_1","E_EC_1_25","E_EC_25_10","E_OC_DOM","E_OC_TRA", \
										"E_OC_25_10","E_PM25","E_OIN_25","E_OIN_10"/)


; settings for "cri_mos_edgar_htap" (emiss_opt==?????)
variable_lists@GAS_cri_mos_edgar_htap = (/"E_CO", "E_NO", "E_NO2",  "E_SO2", "E_NH3"/)
variable_lists@NMVOC_cri_mos_edgar_htap = (/"E_C2H6","E_C3H8","E_NC4H10","E_C2H4","E_C3H6","E_TBUT2ENE",\
									"E_C2H2","E_HCHO","E_CH3CHO","E_C2H5CHO","E_KET","E_MEK",\
									"E_CH3OH","E_C2H5OH","E_HCOOH","E_CH3CO2H","E_BENZENE",\
									"E_TOLUENE","E_OXYL","E_C5H8","E_APINENE","E_BPINENE"/)
variable_lists@AERO_cri_mos_edgar_htap = (/"E_BC_1","E_EC_1_25","E_EC_25_10","E_OC_DOM","E_OC_TRA", \
										"E_OC_25_10","E_PM25","E_OIN_25","E_OIN_10"/)

									




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; generic variable information for the new output files
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Var_Dims  = (/"Time", "emissions_zdim_stag", "south_north", "west_east"/)

GAS_NMVOC_Att = 0.0			; NOTE: this must be a float variable in order for the fill value to work 
GAS_NMVOC_Att@_FillValue  = 9.96921e36
GAS_NMVOC_Att@FieldType   = 104
GAS_NMVOC_Att@stagger     = "Z"
GAS_NMVOC_Att@units       = "mol km^-2 hr^-1"
GAS_NMVOC_Att@description = "EMISSIONS"
GAS_NMVOC_Att@MemoryOrder = "XYZ"

AERO_Att = 0.0 
AERO_Att@_FillValue  = 9.96921e36
AERO_Att@FieldType   = 104
AERO_Att@stagger     = "Z"
AERO_Att@units 	     = "ug m^-2 s^-1" 
AERO_Att@description = "EMISSIONS"
AERO_Att@MemoryOrder = "XYZ"

TZ_Att = 0.0 
TZ_Att@_FillValue  = 9.96921e36
TZ_Att@FieldType   = 104
TZ_Att@stagger     = ""
TZ_Att@units 	   = "hours" 
TZ_Att@description = "Timezone Offset from UTC"
TZ_Att@MemoryOrder = "XY"



end
;*********************************************
