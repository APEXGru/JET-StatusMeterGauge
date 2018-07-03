prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_180100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2018.04.04'
,p_release=>'18.1.0.00.45'
,p_default_workspace_id=>1832690300009983
,p_default_application_id=>119
,p_default_owner=>'DEMO'
);
end;
/
prompt --application/shared_components/plugins/region_type/com_apexconsulting_apex_jet_gauge
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(91906449042210448)
,p_plugin_type=>'REGION TYPE'
,p_name=>'COM.APEXCONSULTING.APEX.JET.GAUGE'
,p_display_name=>'JET Status Meter Gauge'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_javascript_file_urls=>'[require jet]#PLUGIN_FILES#gaugeChart.js'
,p_css_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#IMAGE_PREFIX#libraries/oraclejet/4.2.0/css/libs/oj/v4.2.0/alta/oj-alta-min.css',
'#PLUGIN_FILES#gaugeChart.css'))
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/*',
' * render - function to create placeholder div tag, and initialise the  component',
' */',
' function render ',
'( p_region                in  apex_plugin.t_region',
', p_plugin                in  apex_plugin.t_plugin',
', p_is_printer_friendly   in  boolean ',
') return apex_plugin.t_region_render_result ',
'is',
'  c_region_static_id     constant varchar2(255) := apex_escape.html_attribute( p_region.static_id );',
'  c_orientation          constant varchar2(255) := p_region.attribute_06;',
'  c_height               constant number        := p_region.attribute_07;',
'  c_interval             constant number        := (p_region.attribute_08 * 1000);',
'  l_init_code            varchar2(32767);',
'  l_interval_code        varchar2(32767)        := '''';',
'  l_refresh_code         varchar2(32767);',
'begin',
'  -- Add placeholder div',
'  sys.htp.p (',
'     ''<div class="a-JET-gauge t-BadgeList t-BadgeList--circular t-BadgeList--medium t-BadgeList--stacked ''|| c_orientation ||''" id="'' || c_region_static_id || ''_region" ></div>''',
'  );',
'     ',
'  -- Initialize the chart',
'  l_init_code := ''jet.gauge.init(''||',
'                  ''"'' || c_region_static_id ||''_region",''        || -- pRegionId',
'                  ''"'' || c_height           ||''px",''             || -- height',
'                  ''"'' || c_orientation      || ''",''              || -- Horizontal / Vertical',
'                  ''"'' || apex_plugin.get_ajax_identifier ||''"''   || -- pApexAjaxIdentifier',
'                 '');'';                 ',
'  -- Add refresh interval',
'  if nvl(c_interval,0) > 0 then',
'    l_interval_code := ''t = setTimeout( function(){ apex.event.trigger("#''||c_region_static_id||''","apexrefresh")}, ''|| c_interval || '');'';',
'  end if;  ',
'  ',
'  -- Make it refreshable. First unbind the refresh to prevent double or triple loads',
'  l_refresh_code := ''apex.jQuery("#''||c_region_static_id||''").bind("apexrefresh", function() { '' || ',
'     case when nvl(c_interval,0) > 0 then ''clearTimeout(t);'' end ||',
'     l_init_code || l_interval_code ||'' })'';  ',
'     ',
'  -- Add code to the page   ',
'  apex_javascript.add_onload_code( p_code => ''var t; ''|| l_init_code || l_interval_code || l_refresh_code);  ',
'  ',
'  return null;',
'end render;',
'',
'/*',
' * ajax - function to process SQL query, and output JSON data for legend',
' */',
'function ajax',
'( p_region    in  apex_plugin.t_region',
', p_plugin    in  apex_plugin.t_plugin ',
') return apex_plugin.t_region_ajax_result',
'is',
'  c_value_label_column   constant varchar2(255) := p_region.attribute_01;',
'  c_percent_label_column constant varchar2(255) := p_region.attribute_02;',
'  c_label_label_column   constant varchar2(255) := p_region.attribute_03;',
'  c_color_label_column   constant varchar2(255) := p_region.attribute_04;',
'  c_tooltip_label_column constant varchar2(255) := p_region.attribute_09;',
'  c_url                  constant varchar2(255) := p_region.attribute_05;',
'',
'  l_value_column_no      pls_integer;',
'  l_percent_column_no    pls_integer;',
'  l_label_column_no      pls_integer;',
'  l_color_column_no      pls_integer;',
'  l_tooltip_column_no    pls_integer;',
'',
'  l_value                number;',
'  l_percent              number;',
'  l_label                varchar2(100);',
'  l_color                varchar2(100);',
'  l_url                  varchar2(4000);',
'  l_tooltip              varchar2(4000);',
'',
'  l_column_value_list      apex_plugin_util.t_column_value_list2;',
'',
'begin  ',
'  apex_json.initialize_output (',
'    p_http_cache => false ',
'  );',
'  -- Read the data based on the region source query',
'  l_column_value_list := apex_plugin_util.get_data2 (',
'    p_sql_statement  => p_region.source,',
'    p_min_columns    => 1,',
'    p_max_columns    => null,',
'    p_component_name => p_region.name ',
'  );',
'  ',
'  -- Get the actual column# for faster access and also verify that the data type',
'  -- of the column matches with what we are looking for',
'  l_value_column_no := apex_plugin_util.get_column_no (',
'    p_attribute_label   => ''Value'',',
'    p_column_alias      => c_value_label_column,',
'    p_column_value_list => l_column_value_list,',
'    p_is_required       => true,',
'    p_data_type         => apex_plugin_util.c_data_type_number',
'  );',
'  l_percent_column_no := apex_plugin_util.get_column_no (',
'    p_attribute_label   => ''Percent'',',
'    p_column_alias      => c_percent_label_column,',
'    p_column_value_list => l_column_value_list,',
'    p_is_required       => true,',
'    p_data_type         => apex_plugin_util.c_data_type_number',
'  );',
'  l_label_column_no := apex_plugin_util.get_column_no (',
'    p_attribute_label   => ''Label'',',
'    p_column_alias      => c_label_label_column,',
'    p_column_value_list => l_column_value_list,',
'    p_is_required       => false,',
'    p_data_type         => apex_plugin_util.c_data_type_varchar2',
'  );',
'  l_color_column_no := apex_plugin_util.get_column_no (',
'    p_attribute_label   => ''Color'',',
'    p_column_alias      => c_color_label_column,',
'    p_column_value_list => l_column_value_list,',
'    p_is_required       => false,',
'    p_data_type         => apex_plugin_util.c_data_type_varchar2',
'  );',
'  l_tooltip_column_no := apex_plugin_util.get_column_no (',
'    p_attribute_label   => ''Tooltip'',',
'    p_column_alias      => c_tooltip_label_column,',
'    p_column_value_list => l_column_value_list,',
'    p_is_required       => false,',
'    p_data_type         => apex_plugin_util.c_data_type_varchar2',
'  );',
'',
'  -- begin output as json',
'  owa_util.mime_header(''application/json'', false);',
'  htp.p(''cache-control: no-cache'');',
'  htp.p(''pragma: no-cache'');',
'  owa_util.http_header_close;',
'  apex_json.open_object();',
'',
'  apex_json.open_array(''data'');',
'  for l_row_num in 1 .. l_column_value_list(1).value_list.count loop',
'',
'    apex_json.open_object(); ',
'    -- Set the column values of our current row so that apex_plugin_util.replace_substitutions',
'    -- can do substitutions for columns contained in the region source query.',
'    apex_plugin_util.set_component_values (',
'      p_column_value_list => l_column_value_list,',
'      p_row_num           => l_row_num ',
'    );',
'',
'    l_value := apex_plugin_util.get_value_as_varchar2 (',
'      p_data_type => l_column_value_list(l_value_column_no).data_type,',
'      p_value     => l_column_value_list(l_value_column_no).value_list(l_row_num) ',
'    );',
'    apex_json.open_object(''metricLabel'');',
'    apex_json.write( ''text'', to_char(l_value) ); ',
'    apex_json.close_object();',
'',
'    l_percent := l_column_value_list(l_percent_column_no).value_list(l_row_num).number_value;',
'    apex_json.write(''value'', l_percent); ',
'',
'    if l_label_column_no is not null then',
'      l_label := apex_plugin_util.get_value_as_varchar2 (',
'        p_data_type => l_column_value_list(l_label_column_no).data_type,',
'        p_value     => l_column_value_list(l_label_column_no).value_list(l_row_num) ',
'      );',
'      apex_json.open_object(''label'');',
'      apex_json.write( ''text'', l_label ); ',
'      apex_json.close_object();',
'      apex_json.open_object(''title'');',
'      apex_json.write( ''text'', l_label ); ',
'      apex_json.close_object();',
'    end if;',
'',
'    if l_color_column_no is not null then',
'      l_color := apex_plugin_util.get_value_as_varchar2 (',
'        p_data_type => l_column_value_list(l_color_column_no).data_type,',
'        p_value     => l_column_value_list(l_color_column_no).value_list(l_row_num) ',
'      );',
'      apex_json.write( ''color'', l_color ); ',
'    end if;',
'',
'    if l_tooltip_column_no is not null then',
'      l_tooltip := apex_plugin_util.get_value_as_varchar2 (',
'        p_data_type => l_column_value_list(l_tooltip_column_no).data_type,',
'        p_value     => l_column_value_list(l_tooltip_column_no).value_list(l_row_num) ',
'      );',
'      apex_json.write( ''tooltip'', l_tooltip ); ',
'    end if;',
'',
'    if c_url is not null then',
'      l_url := apex_util.prepare_url (',
'        apex_plugin_util.replace_substitutions (',
'          p_value  => c_url,',
'          p_escape => false )',
'      );',
'      apex_json.write(''url'', l_url);                ',
'    end if;',
'',
'    apex_json.close_object();        ',
'',
'    apex_plugin_util.clear_component_values;',
'',
'  end loop;',
'  apex_json.close_all();',
'    ',
'  return null;',
'',
'end ajax;',
''))
,p_api_version=>1
,p_render_function=>'render'
,p_ajax_function=>'ajax'
,p_standard_attributes=>'SOURCE_SQL:AJAX_ITEMS_TO_SUBMIT:ESCAPE_OUTPUT'
,p_substitute_attributes=>false
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.2.0'
,p_files_version=>186
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(38842982298300276)
,p_plugin_id=>wwv_flow_api.id(91906449042210448)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Value column'
,p_attribute_type=>'REGION SOURCE COLUMN'
,p_is_required=>true
,p_column_data_types=>'VARCHAR2:NUMBER'
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>false
,p_help_text=>'Select the column from the region SQL Query that holds the shown value for the gauge.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(38843549872304111)
,p_plugin_id=>wwv_flow_api.id(91906449042210448)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Percent column'
,p_attribute_type=>'REGION SOURCE COLUMN'
,p_is_required=>true
,p_column_data_types=>'NUMBER'
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>false
,p_help_text=>'Select the column from the region SQL Query that holds the percentage for the gauge.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(38844185871308585)
,p_plugin_id=>wwv_flow_api.id(91906449042210448)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Label column'
,p_attribute_type=>'REGION SOURCE COLUMN'
,p_is_required=>false
,p_column_data_types=>'VARCHAR2'
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>false
,p_help_text=>'Select the column from the region SQL Query that holds the label value for the gauge.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(38844846828311150)
,p_plugin_id=>wwv_flow_api.id(91906449042210448)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Color column'
,p_attribute_type=>'REGION SOURCE COLUMN'
,p_is_required=>false
,p_column_data_types=>'VARCHAR2'
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>false
,p_help_text=>'Select the column from the region SQL Query that holds the color for the gauge.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(38845512264316924)
,p_plugin_id=>wwv_flow_api.id(91906449042210448)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Link Target'
,p_attribute_type=>'LINK'
,p_is_required=>false
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>false
,p_help_text=>'Enter a target page to be called when the user clicks a gauge.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(39118402260492593)
,p_plugin_id=>wwv_flow_api.id(91906449042210448)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Orientation'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'Horizontal'
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(39119619432493291)
,p_plugin_attribute_id=>wwv_flow_api.id(39118402260492593)
,p_display_sequence=>10
,p_display_value=>'Horizontal'
,p_return_value=>'Horizontal'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(39119936353494098)
,p_plugin_attribute_id=>wwv_flow_api.id(39118402260492593)
,p_display_sequence=>20
,p_display_value=>'Vertical'
,p_return_value=>'Vertical'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(39214088679948978)
,p_plugin_id=>wwv_flow_api.id(91906449042210448)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Height'
,p_attribute_type=>'INTEGER'
,p_is_required=>true
,p_default_value=>'50'
,p_display_length=>3
,p_max_length=>3
,p_unit=>'px'
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(19931171406937339)
,p_plugin_id=>wwv_flow_api.id(91906449042210448)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Automatic refresh after'
,p_attribute_type=>'NUMBER'
,p_is_required=>false
,p_is_common=>false
,p_show_in_wizard=>false
,p_display_length=>3
,p_max_length=>3
,p_unit=>'seconds'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Enter the interval between chart updates. Very small update intervals, such as 2 seconds, are discouraged since they may cause serious database performance issues.',
'Leave empty for no automatic refresh.'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(20606287057873724)
,p_plugin_id=>wwv_flow_api.id(91906449042210448)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>35
,p_prompt=>'Tooltip'
,p_attribute_type=>'REGION SOURCE COLUMN'
,p_is_required=>false
,p_column_data_types=>'VARCHAR2'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_is_translatable=>false
,p_help_text=>'The column that contains the tooltip value.'
);
wwv_flow_api.create_plugin_std_attribute(
 p_id=>wwv_flow_api.id(38804082748853424)
,p_plugin_id=>wwv_flow_api.id(91906449042210448)
,p_name=>'SOURCE_SQL'
,p_sql_min_column_count=>1
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'elect ename||'' - ''||job||''@''||dname "name"',
'             ,      ''human'' "shape"',
'             ,      count(*) over (partition by job) "count"',
'             ,      case job',
'                    when ''PRESIDENT'' then ''black''',
'                    when ''ANALYST''   then ''blue''',
'                    when ''CLERK''     then ''green''',
'                    when ''MANAGER''   then ''red''',
'                    when ''SALESMAN''  then ''yellow''',
'                    end "color"',
'             from   emp',
'                    join dept on emp.deptno = dept.deptno',
'             order by emp.job;'))
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '212066756E6374696F6E20286A65742C20242C207365727665722C207574696C2C20646562756729207B0A202020202275736520737472696374223B0A200A202020206A65742E6761756765203D207B0A2020202020202020696E69743A2066756E6374';
wwv_flow_api.g_varchar2_table(2) := '696F6E202870526567696F6E49642C20704865696768742C20704F7269656E746174696F6E2C207041706578416A61784964656E74696669657229207B0A20202020202020202020202072657175697265285B226F6A732F6F6A636F7265222C20226A71';
wwv_flow_api.g_varchar2_table(3) := '75657279222C20226F6A732F6F6A6761756765225D2C2066756E6374696F6E20286F6A2C202429207B0A202020202020202020202020202020207365727665722E706C7567696E287041706578416A61784964656E7469666965722C207B7D2C207B0A20';
wwv_flow_api.g_varchar2_table(4) := '20202020202020202020202020202020202020737563636573733A2066756E6374696F6E2028704461746129207B0A202020202020202020202020202020202020202020202020202020202428222322202B70526567696F6E4964292E656D7074792829';
wwv_flow_api.g_varchar2_table(5) := '3B2020200A202020202020202020202020202020202020202020202020202020207661722067617567654469762C2068746D6C2C2069203D20302C20773B0A2020202020202020202020202020202020202020202020202020202077203D2028704F7269';
wwv_flow_api.g_varchar2_table(6) := '656E746174696F6E203D3D2022486F72697A6F6E74616C22293F4D6174682E666C6F6F7228202428222322202B2070526567696F6E4964292E77696474682829202F2070446174612E646174612E6C656E6774682029202B20227078223A223130302522';
wwv_flow_api.g_varchar2_table(7) := '3B0A2020202020202020202020202020202020202020202020202020202070446174612E646174612E666F7245616368280A2020202020202020202020202020202020202020202020202020202020202066756E6374696F6E28206974656D20297B0A20';
wwv_flow_api.g_varchar2_table(8) := '202020202020202020202020202020202020202020202020202020202020202069203D2069202B20313B0A2020202020202020202020202020202020202020202020202020202020202020206761756765446976203D2070526567696F6E4964202B2022';
wwv_flow_api.g_varchar2_table(9) := '5F676175676522202B20693B0A202020202020202020202020202020202020202020202020202020202020202020766172206C55726C203D206974656D2E75726C3F6974656D2E75726C3A2723273B0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(10) := '2020202020202020202020202068746D6C203D20273C6120687265663D2227202B206C55726C202B2027223E270A20202020202020202020202020202020202020202020202020202020202020202020202020202B20273C64697620636C6173733D2261';
wwv_flow_api.g_varchar2_table(11) := '2D4A45542D67617567652D636F6E7461696E6572222069643D2227202B206761756765446976202B202722207374796C653D2277696474683A272B2077202B20273B6865696768743A27202B2070486569676874202B20273B223E3C2F6469763E270A20';
wwv_flow_api.g_varchar2_table(12) := '202020202020202020202020202020202020202020202020202020202020202020202020202B20273C646976206964203D22272B20676175676544697620202B275F7469746C652220636C6173733D22742D42616467654C6973742D6C6162656C20742D';
wwv_flow_api.g_varchar2_table(13) := '42616467654C6973742D6C6162656C2D2D626F74746F6D2220227374796C653D2277696474683A272B2077202B20273B223E3C2F6469763E270A20202020202020202020202020202020202020202020202020202020202020202020202020202B20273C';
wwv_flow_api.g_varchar2_table(14) := '2F613E27203B0A2020202020202020202020202020202020202020202020202020202020202020202428222322202B2070526567696F6E4964292E617070656E642868746D6C293B0A202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(15) := '2020202020202428222322202B206761756765446976202B20225F7469746C6522292E74657874286974656D2E6C6162656C2E74657874293B0A2020202020202020202020202020202020202020202020202020202020202020202428222322202B2067';
wwv_flow_api.g_varchar2_table(16) := '61756765446976290A20202020202020202020202020202020202020202020202020202020202020202020202E6F6A5374617475734D657465724761756765287B20226F7269656E746174696F6E2220202020202020202020203A202263697263756C61';
wwv_flow_api.g_varchar2_table(17) := '72222C0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202022616E696D6174696F6E4F6E446973706C617922202020203A20226175746F222C0A2020202020';
wwv_flow_api.g_varchar2_table(18) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202022616E696D6174696F6E4F6E446174614368616E676522203A20226175746F222C0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(19) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020202276616C75652220202020202020202020202020202020203A206974656D2E76616C75652C0A2F2F2020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(20) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020226D65747269634C6162656C2220202020202020202020203A207B20227465787422203A206974656D2E6D65747269634C6162656C2E74657874207D';
wwv_flow_api.g_varchar2_table(21) := '2C0A2F2F202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020226C6162656C2220202020202020202020202020202020203A207B20227465787422203A206974';
wwv_flow_api.g_varchar2_table(22) := '656D2E6C6162656C2E74657874207D2C0A2F2F202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020227469746C65222020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(23) := '3A207B20227465787422203A20222022207D2C0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202022636F6C6F722220202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(24) := '203A206974656D2E636F6C6F722C0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202022636C6173732220202020202020202020202020202020203A202261';
wwv_flow_api.g_varchar2_table(25) := '2D4A45542D7374617475734D657465724761756765222C0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202022746F6F6C7469702220202020202020202020';
wwv_flow_api.g_varchar2_table(26) := '20202020203A207B202272656E646572657222203A2066756E6374696F6E282064617461436F6E74657874297B0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(27) := '202020202020202020202020202020202020202020202020202020202020202076617220746F6F6C746970203D20646F63756D656E742E637265617465456C656D656E74282264697622293B0A2020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(28) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202076617220746F6F6C74697054657874203D20646F63756D656E742E637265617465456C656D';
wwv_flow_api.g_varchar2_table(29) := '656E7428227370616E22293B0A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202074';
wwv_flow_api.g_varchar2_table(30) := '6F6F6C746970546578742E74657874436F6E74656E74203D200A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(31) := '20202020202020202020202020206974656D2E746F6F6C746970207C7C206974656D2E6C6162656C2E74657874202B2022203A2022202B206974656D2E6D65747269634C6162656C2E746578743B0A202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(32) := '202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020746F6F6C7469702E617070656E644368696C642820746F6F6C';
wwv_flow_api.g_varchar2_table(33) := '7469705465787420293B0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(34) := '2020202020202072657475726E20746F6F6C7469703B0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(35) := '2020202020202020202020202020202020207D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(36) := '202020207D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020207D293B0A202020202020202020202020202020202020202020202020202020207D293B0A20202020';
wwv_flow_api.g_varchar2_table(37) := '202020202020202020202020202020207D0A202020202020202020202020202020207D293B0A2020202020202020202020207D293B0A20202020202020207D2C0A2020202020202020726566726573683A2066756E6374696F6E202870526567696F6E49';
wwv_flow_api.g_varchar2_table(38) := '642C20704865696768742C20704F7269656E746174696F6E2C207041706578416A61784964656E74696669657229207B0A202020202020202020202020696E69742870526567696F6E49642C20704865696768742C20704F7269656E746174696F6E2C20';
wwv_flow_api.g_varchar2_table(39) := '7041706578416A61784964656E746966696572293B0A20202020202020207D0A202020207D0A7D2877696E646F772E6A6574203D2077696E646F772E6A6574207C7C207B7D2C20617065782E6A51756572792C20617065782E7365727665722C20617065';
wwv_flow_api.g_varchar2_table(40) := '782E7574696C2C20617065782E6465627567293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(38646191484036755)
,p_plugin_id=>wwv_flow_api.id(91906449042210448)
,p_file_name=>'gaugeChart.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E612D4A45542D676175676520726563747B0D0A09637572736F72203A206175746F3B0D0A7D0D0A0D0A2E612D4A45542D67617567652E486F72697A6F6E74616C207B0D0A202020206D617267696E2D746F702020203A203870783B0D0A7D0D0A0D0A2E';
wwv_flow_api.g_varchar2_table(2) := '612D4A45542D67617567652E486F72697A6F6E74616C2061207B0D0A20202020646973706C6179203A207461626C652D63656C6C3B0D0A7D0D0A0D0A2E612D4A45542D67617567652E742D42616467654C697374202E742D42616467654C6973742D6C61';
wwv_flow_api.g_varchar2_table(3) := '62656C2E742D42616467654C6973742D6C6162656C2D2D626F74746F6D20207B0D0A20202020706F736974696F6E203A2072656C61746976653B0D0A2020202070616464696E672D6C656674203A203070783B0D0A2020202070616464696E672D726967';
wwv_flow_api.g_varchar2_table(4) := '6874203A203070783B0D0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(39124091944558188)
,p_plugin_id=>wwv_flow_api.id(91906449042210448)
,p_file_name=>'gaugeChart.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
