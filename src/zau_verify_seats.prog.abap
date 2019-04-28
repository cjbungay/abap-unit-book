Report ZAU_VERIFY_SEATS.

data:
  gs_sflight      type sflight,
  gs_saplane      type saplane,
  gd_sflight_max  type i,
  gd_sflight_free type i.

start-of-selection.

* Anhand des Flugzeugtyps der Fluggesellscahft wird die *
* maximale Anzahl an Sitzplätzen selektiert,
* die aktuell belegt sind.
  select single *
    from sflight
    into gs_sflight
      where carrid = 'LH'
        and planetype = 'A319'.

* In dem Feld SEATSMAX, SEATSMAX_B und SEATSMAX_F
* ist die Belegung enthalten. Diese Werte werden addiert
* und ergeben die Anzahl der maximal belegten Plätze.
  gd_sflight_max = ( gs_sflight-seatsmax + gs_sflight-seatsmax_b +
gs_sflight-seatsmax_f ).

* Nun wird die Anzahl gegen das Fassungsvermögen des Flugzeuges geprüft.
  select single *
    from saplane
    into gs_saplane
      where planetype = 'A319'.

* Nun ermitteln wir die Anzahl der freien Plätze und geben diese
* weiter an das Callcenter
  gd_sflight_free = gd_sflight_max - ( gs_saplane-seatsmax +
gs_saplane-seatsmax_b + gs_saplane-seatsmax_f ).

  write:
    /01 '  Aktuell belegt:', gd_sflight_max,
    /01 'Freie Sitzplätze:', gd_sflight_free.

class lcl_test definition for testing.
  "#AU Risk_Level Harmless
  "#AU Duration   Short

public section.
  methods:
    t1 for testing.
endclass.

class lcl_test implementation.
  method t1.

* Anzahl an Sitzplätzen ermitteln
    data:
      ls_saplane type saplane,
      ld_seats type i.

    select single *
      from saplane
      into ls_saplane
        where planetype = 'A319'.

*   Fassungsvermögen des Flugzeugs
    ld_seats = ( ls_saplane-seatsmax + ls_saplane-seatsmax_b +
ls_saplane-seatsmax_f ).

*   Reduzierung um den bekannten ermittelten Wert (60)
    ld_seats = ld_seats - 60.
*   ld_seats enthält nun die frei vergügbare Anzahl
*   an Sitzen, diese müssten mit der Variablen
*   gd_sflight_max übereinstimmen, denn dort sind die
*   freien Sitzplätze selektiert.
    cl_aunit_assert=>assert_equals(
      act = ld_seats
      exp = 280
      msg = 'Anzahl entspricht nicht Datenbankinhalt!' ).
  endmethod.
Endclass.
