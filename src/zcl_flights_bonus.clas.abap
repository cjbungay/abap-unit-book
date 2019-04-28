*----------------------------------------------------------------------*
*       CLASS ZCL_FLIGHTS_BONUS  DEFINITIO
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class zcl_flights_bonus definition
  public
  create public .

*"* public components of class ZCL_FLIGHTS_BONUS
*"* do not include other source files here!!!
  public section.

    types:
      begin of ty_sflight,
        carrid     type s_carr_id,
        connid     type s_conn_id,
        fldate     type s_date,
        planetype  type s_planetye,
        seatsmax   type s_seatsmax,
        seatsmax_b type s_smax_b,
        seatsmax_f type s_smax_f,
        countryfr  type land1,
        cityfrom   type s_from_cit,
        countryto  type land1,
        cityto     type s_to_city,
        distance   type s_distance,
        distid     type s_distid,
        bonus      type p length 5 decimals 3,  "Bonusbetrag
      end of ty_sflight .
    types:
      ty_sflights type standard table of ty_sflight .

    methods constructor
      importing
        !it_carrid type any table
        !it_fldate type any table
        !it_cityfrom type any table
        !it_cityto type any table
      exceptions
        initial_parameters .
    methods accessing .
protected section.
*"* protected components of class ZCL_FLIGHTS_BONUS
*"* do not include other source files here!!!

  methods SELECTION .
  methods REDUCE .
  methods MODIFY .
  methods UPLOAD .
  methods DISPLAY .
private section.
*"* private components of class ZCL_FLIGHTS_BONUS
*"* do not include other source files here!!!

  data MS_FLIGHT type TY_SFLIGHT .
  data MT_FLIGHTS type TY_SFLIGHTS .
  data mt_carrid type range of s_carr_id .
  data mt_fldate type range of  s_date.
  data mt_cityfrom type range of s_from_cit .
  data mt_cityto type range of s_to_city.
ENDCLASS.



CLASS ZCL_FLIGHTS_BONUS IMPLEMENTATION.


method accessing.
*/-------------------------------------------------------------------\*
*| Hier erfolgt die tatsächliche Verarbeitung der Klasse             |*
*\-------------------------------------------------------------------/*

  me->selection( ).
  me->reduce( ).
  me->modify( ).
  me->upload( ).
  me->display( ).

endmethod.


method constructor.
*/-------------------------------------------------------------------\*
*| Prüfen der Schnittstellenparameter und setzen der Attribute       |*
*\-------------------------------------------------------------------/*

  if it_carrid   is initial or
     it_cityfrom is initial or
     it_cityto   is initial.
    raise initial_parameters.
  endif.

  me->mt_carrid   = it_carrid.
  me->mt_fldate   = it_fldate.
  me->mt_cityfrom = it_cityfrom.
  me->mt_cityto   = it_cityto.

endmethod.


method display.
*/-------------------------------------------------------------------\*
*| Anzeige der Verarbeitungsdaten                                    |*
*\-------------------------------------------------------------------/*

  break-point id zau_display.

  data:
    ls_flight type me->ty_sflight.

  loop at me->mt_flights into ls_flight.

    write:
      /01 ls_flight-carrid,
      10 ls_flight-fldate,
      22 ls_flight-cityfrom,
      42 ls_flight-cityto,
      62 ls_flight-planetype.

  endloop.

endmethod.


method modify.
*/-------------------------------------------------------------------\*
*| Ändern der Verarbeitungsdaten - Bonusbetrag wird ermittelt        |*
*\-------------------------------------------------------------------/*

  break-point id zau_modify.

endmethod.


method reduce.
*/-------------------------------------------------------------------\*
*| Reduzierung der Verarbeitungsdaten                                |*
*| Zur Bonusberechnung werden nur die ungeraden Inhalte verwendet    |*
*\-------------------------------------------------------------------/*

  data:
    lt_flights_copy type ty_sflights,
    ls_flights_copy type ty_sflight.

  break-point id zau_reduce.

endmethod.


method selection.
*/-------------------------------------------------------------------\*
*| Datenselektion anhand der Attribut-Tabellen                       |*
*\-------------------------------------------------------------------/*

  break-point id zau_select.

  select
    sflight~carrid
    sflight~connid
    sflight~fldate
    sflight~planetype
    sflight~seatsmax
    sflight~seatsmax_b
    sflight~seatsmax_f
    spfli~countryfr
    spfli~cityfrom
    spfli~countryto
    spfli~cityto
    spfli~distance
    spfli~distid
      into table me->mt_flights
        from ( sflight as sflight
        inner join spfli as spfli
        on  sflight~carrid = spfli~carrid
        and sflight~connid = spfli~connid )
          where sflight~carrid in me->mt_carrid
          and sflight~fldate in me->mt_fldate
          and spfli~cityfrom in me->mt_cityfrom
          and spfli~cityto   in me->mt_cityto.

endmethod.


method upload.
*/-------------------------------------------------------------------\*
*| Ergebnistabelle wird weggeschrieben                               |*
*\-------------------------------------------------------------------/*

  break-point id zau_upload.

endmethod.
ENDCLASS.
