class ZCL_FLIGHT_APPLICATION definition
  public
  create public .

*"* public components of class ZCL_FLIGHT_APPLICATION
*"* do not include other source files here!!!
public section.

  class-methods INITIALIZE
    importing
      !IT_CARRID type ANY TABLE
      !IT_FLDATE type ANY TABLE
      !IT_CITYFROM type ANY TABLE
      !IT_CITYTO type ANY TABLE .
protected section.
*"* protected components of class ZCL_FLIGHT_APPLICATION
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_FLIGHT_APPLICATION
*"* do not include other source files here!!!

  class-data MO_FLIGHT_BONUS type ref to ZCL_FLIGHTS_BONUS .
ENDCLASS.



CLASS ZCL_FLIGHT_APPLICATION IMPLEMENTATION.


method initialize.
*/-------------------------------------------------------------------\*
*| Initialisierungs- und Verarbeitungsmethode                        |*
*\-------------------------------------------------------------------/*

  create object zcl_flight_application=>mo_flight_bonus
    exporting
      it_carrid   = it_carrid
      it_fldate   = it_fldate
      it_cityfrom = it_cityfrom
      it_cityto   = it_cityto
    exceptions
      initial_parameters = 1
      others             = 2.

* Hier könnte die Exception weiter gereicht werden, falls die Schnittstellenparameter
* leer wären. Dies geschieht nicht an dieser Stelle, da vor diesen Auruf schon die ASSERT-Bedingungen
* greifen.

  zcl_flight_application=>mo_flight_bonus->accessing( ).

endmethod.
ENDCLASS.
