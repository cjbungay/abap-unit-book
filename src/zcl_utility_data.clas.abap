class ZCL_UTILITY_DATA definition
  public
  create public .

*"* public components of class ZCL_UTILITY_DATA
*"* do not include other source files here!!!
public section.

  methods CONSTRUCTOR
    importing
      !ID_ECATT_TEST_DATA_NAME type ETOBJ_NAME .
  methods GET_VARIANT_VALUES
    importing
      !ID_VAR_NAME type ETVAR_ID
    returning
      value(RS_ETPAR_VALUES) type ETPAR_VARI .
protected section.
*"* protected components of class ZCL_UTILITY_DATA
*"* do not include other source files here!!!
private section.
*"* private components of class ZCL_UTILITY_DATA
*"* do not include other source files here!!!

  data MD_ECATT_NAME type ETOBJ_NAME .
  data MS_ECATT_DATA type ETPAR_VARI .
  data MT_ECATT_DATA type ETPAR_VARI_TABTYPE .

  methods READ_TEST_DATA .
ENDCLASS.



CLASS ZCL_UTILITY_DATA IMPLEMENTATION.


method constructor.
*/-------------------------------------------------------------------\*
*| Setzen der Attributwerte und lesen der eCATT-Daten                |*
*\-------------------------------------------------------------------/*

  me->md_ecatt_name = id_ecatt_test_data_name.
  me->read_test_data( ).

endmethod.


method get_variant_values.
*/-------------------------------------------------------------------\*
*| Daten der eCATT-Variante ausgeben                                 |*
*\-------------------------------------------------------------------/*

  data:
    ls_ecatt_data type etpar_vari.

  loop at me->mt_ecatt_data into ls_ecatt_data
    where var_name = id_var_name.

    rs_etpar_values = ls_ecatt_data.
    return.

  endloop.

endmethod.


method read_test_data.
*/-------------------------------------------------------------------\*
*| Lesen der eCATT-Daten                                             |*
*\-------------------------------------------------------------------/*

  data:
    lo_root      type ref to cx_root,
    lo_test_data type ref to cl_apl_ecatt_test_data.

  try.
      create object lo_test_data
        exporting
          im_name = me->md_ecatt_name.

      try.
          lo_test_data->read( ).
          me->mt_ecatt_data = lo_test_data->params->param_val_tab.

          delete me->mt_ecatt_data where var_name = 'ECATTDEFAULT'.

        catch cx_ecatt_apl into lo_root.
      endtry.

    catch cx_ecatt_apl into lo_root.
  endtry.

endmethod.
ENDCLASS.
