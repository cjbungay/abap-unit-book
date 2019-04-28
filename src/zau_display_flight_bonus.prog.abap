report  zau_display_flight_bonus.
************************************************************************
* Inline-Kurzdokumentation:
************************************************************************
* KURZBESCHREIBUNG
*   Dieser Report stellt die Bonus-Flugdaten dar.
************************************************************************

*---------------------------------------------------------------------*
* D A T E N   D E F I N I T I O N E N
*---------------------------------------------------------------------*

data:
  gs_flight type zcl_flights_bonus=>ty_sflight.

*---------------------------------------------------------------------*
* S E L E K T I O N S B I L D
*---------------------------------------------------------------------*

select-options:
  s_car   for gs_flight-carrid,
  s_date  for gs_flight-fldate,
  s_city  for gs_flight-cityfrom,
  s_citto for gs_flight-cityto.

*---------------------------------------------------------------------*
* B E G I N N   D E R   V E R A R B E I T U N G
*---------------------------------------------------------------------*
start-of-selection.

  assert id zau_starter condition:
    s_car[]   is not initial,
    s_date[]  is not initial,
    s_city[]  is not initial,
    s_citto[] is not initial.

  zcl_flight_application=>initialize(
      it_carrid   = s_car[]
      it_fldate   = s_date[]
      it_cityfrom = s_city[]
      it_cityto   = s_citto[] ).
