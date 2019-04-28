*----------------------------------------------------------------------*
*       CLASS lcl_abap_unit_testclass DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class lcl_abap_unit_testclass definition deferred.
class zcl_flights_bonus definition local friends
  lcl_abap_unit_testclass.

*----------------------------------------------------------------------*
*       CLASS lcl_abap_unit_testclass DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class lcl_abap_unit_testclass definition for testing.
  "#AU Duration Medium
  "#AU Risk_Level Harmless

  public section.
    methods:
      _check_attributes         for testing,
      _check_carrid_exception   for testing,
      _check_cityfrom_exception for testing.

  private section.

    methods:
      setup,
      teardown.

    data:
      mo_ref   type ref to zcl_flights_bonus,
      mt_car   type range of
        zcl_flights_bonus=>ty_sflight-carrid,
      mt_date  type range of
        zcl_flights_bonus=>ty_sflight-fldate,
      mt_city  type range of
        zcl_flights_bonus=>ty_sflight-cityfrom,
      mt_citto type range of
        zcl_flights_bonus=>ty_sflight-cityto.

endclass.       "Abap_Unit_Testclass
* ----------------------------------------------------------------------
class lcl_abap_unit_testclass implementation.

  method _check_cityfrom_exception.
*   Testcoding
    data:
      lo_test_data  type ref to zcl_utility_data,
      ls_variants   type etpar_vari,
      ls_par_values type etpar_vals,

      ls_car        like line of mt_car,
      ls_date       like line of mt_date,
      ls_citto      like line of mt_citto.

*   Initialisieren der Parameter
    clear:
      me->mt_car, me->mt_date,
      me->mt_city, me->mt_citto.

*   Instanz der Utility-Klasse erzeugen
    create object lo_test_data
      exporting
        id_ecatt_test_data_name = 'ZAU_TD'.

*   Lesen der Inahlte zur Variante V1
    ls_variants = lo_test_data->get_variant_values( 'V1' ).

*   Übergabetabellen aufbauen
    loop at ls_variants-par_values into ls_par_values.
      case ls_par_values-pname.
        when 'P_CARR'.
          ls_car-low = ls_par_values-value.
          append ls_car to me->mt_car.
        when 'P_DATE'.
          ls_date-low = ls_par_values-value.
          append ls_date to me->mt_date.
        when 'P_CITYTO'.
          ls_citto-low = ls_par_values-value.
          append ls_citto to me->mt_citto.
      endcase.
    endloop.

    create object mo_ref
      exporting
        it_carrid   = mt_car
        it_fldate   = mt_date
        it_cityfrom = mt_city
        it_cityto   = mt_citto
      exceptions
        initial_parameters = 1
        others             = 2.

*   Prüfmethoden
    cl_aunit_assert=>assert_subrc(
      act = sy-subrc
      exp = 1
      msg = 'CITYFROM-Ausnahme nicht geworfen!' ).

  endmethod.                    "_check_cityfrom_exception

  method setup.
*   Diese Strukturen sind nur beim SETUP notwendig
    data:
      ls_car   like line of mt_car,
      ls_date  like line of mt_date,
      ls_city  like line of mt_city,
      ls_citto like line of mt_citto.

*   Testcoding
    ls_car-low = 'LH'.
    append ls_car to mt_car.
    ls_date-low = '28.03.2005'.
    append ls_date  to mt_date.
    ls_city-low = 'FRANKFURT'.
    append ls_city to mt_city.
    ls_citto-low = 'NEW YORK'.
    append ls_citto to mt_citto.

  endmethod.                    "setup

  method teardown.
    free: mo_ref.
  endmethod.                    "teardown

  method _check_attributes.
*   Testcoding
    create object mo_ref
      exporting
        it_carrid   = mt_car
        it_fldate   = mt_date
        it_cityfrom = mt_city
        it_cityto   = mt_citto
      exceptions
        initial_parameters = 1
        others             = 2.

*   Prüfmethoden
    cl_aunit_assert=>assert_not_initial(
      act  = mo_ref->mt_carrid
      msg  = 'CARRID ist leer!'
      quit = cl_aunit_assert=>no ).

    cl_aunit_assert=>assert_not_initial(
      act  = mo_ref->mt_fldate
      msg  = 'Datum ist leer!'
      quit = cl_aunit_assert=>no ).

    cl_aunit_assert=>assert_not_initial(
      act  = mo_ref->mt_cityfrom
      msg  = 'Abflugstadt ist leer!'
      quit = cl_aunit_assert=>no ).

    cl_aunit_assert=>assert_not_initial(
      act  = mo_ref->mt_cityto
      msg  = 'Ankunftstadt ist leer!'
      quit = cl_aunit_assert=>no ).

  endmethod.                    "_check_attributes

  method _check_carrid_exception.
*   Testcoding -> CARRID initialisieren
    clear mt_car.

    create object mo_ref
      exporting
        it_carrid   = mt_car
        it_fldate   = mt_date
        it_cityfrom = mt_city
        it_cityto   = mt_citto
      exceptions
        initial_parameters = 1
        others             = 2.

*   Prüfmethoden
    cl_aunit_assert=>assert_subrc(
      act = sy-subrc
      exp = 1
      msg = 'CARRID-Ausnahme nicht geworfen!' ).

  endmethod.                    "_check_carrid_exception

endclass.       "Abap_Unit_Testclass
