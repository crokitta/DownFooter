set define off
set verify off
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end;
/
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_040200 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>nvl(wwv_flow_application_install.get_workspace_id,7425722454134845));
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'en'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2012.01.01');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := nvl(wwv_flow_application_install.get_application_id,115);
   wwv_flow_api.g_id_offset := nvl(wwv_flow_application_install.get_offset,0);
null;
 
end;
/

prompt  ...ui types
--
 
begin
 
null;
 
end;
/

prompt  ...plugins
--
--application/shared_components/plugins/dynamic_action/nl_rokit_downboy
 
begin
 
wwv_flow_api.create_plugin (
  p_id => 119349149090340872 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_type => 'DYNAMIC ACTION'
 ,p_name => 'NL.ROKIT.DOWNBOY'
 ,p_display_name => 'Down Footer'
 ,p_category => 'STYLE'
 ,p_supported_ui_types => 'DESKTOP'
 ,p_image_prefix => '#PLUGIN_PREFIX#'
 ,p_plsql_code => 
'function downboy(p_dynamic_action in apex_plugin.t_dynamic_action, p_plugin in apex_plugin.t_plugin)'||unistr('\000a')||
'   return apex_plugin.t_dynamic_action_render_result'||unistr('\000a')||
'is'||unistr('\000a')||
'   v_result      apex_plugin.t_dynamic_action_render_result;'||unistr('\000a')||
'   v_init_js     varchar2(32767);'||unistr('\000a')||
'   v_elmsel      p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;'||unistr('\000a')||
'   v_jquerysel   p_dynamic_action.attribute_02%type := p_dynam'||
'ic_action.attribute_02;'||unistr('\000a')||
'begin'||unistr('\000a')||
'   if apex_application.g_debug'||unistr('\000a')||
'   then'||unistr('\000a')||
'      apex_plugin_util.debug_dynamic_action(p_plugin => p_plugin, p_dynamic_action => p_dynamic_action);'||unistr('\000a')||
'      apex_debug.message(''p_dynamic_action.attribute_01 = '' || v_elmsel);'||unistr('\000a')||
'      apex_debug.message(''p_dynamic_action.attribute_02 = '' || v_jquerysel);'||unistr('\000a')||
'   end if;'||unistr('\000a')||
''||unistr('\000a')||
'   if v_elmsel = ''ut-footer'''||unistr('\000a')||
'   then'||unistr('\000a')||
'      apex_javascript.add_'||
'library(p_name => ''jquery.downboy.auto.min'', p_directory => p_plugin.file_prefix);'||unistr('\000a')||
'      v_init_js      :='||unistr('\000a')||
'         ''function downBoyInitUT(){var marginTop=$("div#t_Body_content").css("margin-top");var marginTopVal=marginTop.substr(0,marginTop.length-2);var newHeight=$(window).height()-marginTopVal;$("div#t_Body_content").css("min-height",newHeight+"px")}'';'||unistr('\000a')||
'      v_init_js      :='||unistr('\000a')||
'         v_init_'||
'js || ''function downBoyInit(){console.log("downBoy: init on UT-footer");if($("footer").length){downBoyInitUT();downBoy("footer"); window.onresize = function() {downBoyInitUT();downBoy("footer");};}}'';'||unistr('\000a')||
'      apex_javascript.add_library(p_name => ''jquery.downboy.min'', p_directory => p_plugin.file_prefix);'||unistr('\000a')||
'   elsif v_elmsel = ''footer-tag'''||unistr('\000a')||
'   then'||unistr('\000a')||
'      apex_javascript.add_library(p_name => ''jquery.do'||
'wnboy.auto.min'', p_directory => p_plugin.file_prefix);'||unistr('\000a')||
'      v_init_js   := ''function downBoyInit(){console.log("downBoy: init on FOOTER element");}'';'||unistr('\000a')||
'   else'||unistr('\000a')||
'      v_init_js      :='||unistr('\000a')||
'         ''function downBoyInit(){console.log("downBoy: init on jQuery selector: '' ||'||unistr('\000a')||
'         v_jquerysel ||'||unistr('\000a')||
'         ''");if ($("'' ||'||unistr('\000a')||
'         v_jquerysel ||'||unistr('\000a')||
'         ''").length) {downBoy("'' ||'||unistr('\000a')||
'         v_jquerysel ||'||
''||unistr('\000a')||
'         ''"); window.onresize = function() {downBoy("'' ||'||unistr('\000a')||
'         v_jquerysel ||'||unistr('\000a')||
'         ''")}} else {console.log("downBoy: jQuery selector: '' ||'||unistr('\000a')||
'         v_jquerysel ||'||unistr('\000a')||
'         '' does not exist")}}'';'||unistr('\000a')||
'      apex_javascript.add_library(p_name => ''jquery.downboy.min'', p_directory => p_plugin.file_prefix);'||unistr('\000a')||
'   end if;'||unistr('\000a')||
''||unistr('\000a')||
'   apex_javascript.add_inline_code(p_code => v_init_js, p_key => null);'||unistr('\000a')||
'   v_res'||
'ult.javascript_function   := ''downBoyInit'';'||unistr('\000a')||
'   return v_result;'||unistr('\000a')||
'end;'
 ,p_render_function => 'downboy'
 ,p_substitute_attributes => true
 ,p_subscribe_plugin_settings => true
 ,p_help_text => '<p>'||unistr('\000a')||
'	<span style="color: rgb(51, 51, 51); font-family: ''Helvetica Neue'', Helvetica, ''Segoe UI'', Arial, freesans, sans-serif, ''Apple Color Emoji'', ''Segoe UI Emoji'', ''Segoe UI Symbol''; font-size: 16px; line-height: 25.6px;">A small APEX jQuery plugin to push your footer to the bottom of your responsive dynamic height page. Based on the DownBoy jQuery Plugin.</span></p>'||unistr('\000a')||
'<p>'||unistr('\000a')||
'	<font color="#333333" face="Helvetica Neue, Helvetica, Segoe UI, Arial, freesans, sans-serif, Apple Color Emoji, Segoe UI Emoji, Segoe UI Symbol"><span style="font-size: 16px; line-height: 25.6px;">APEX adaptation by Christian Rokitta, 2016/02.</span></font></p>'||unistr('\000a')||
''
 ,p_version_identifier => '1.1'
 ,p_about_url => 'https://github.com/crokitta/DownFooter'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 119352140149466561 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 119349149090340872 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 10
 ,p_prompt => 'Element Selection'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'footer-tag'
 ,p_is_translatable => false
 ,p_help_text => '<b>Footer Element:</b> Apply to the existing FOOTER HTML element on the page. This option works fine if the footer element exists and has no container parent elements.<p>'||unistr('\000a')||
'<b>jQuery Selector:</b> Apply to the element matching the jQuery selector. Use this option if there is no footer HTML element or if you want to apply this function on a different element.<p>'||unistr('\000a')||
'<b>UT Footer (APEX 5 UT only):</b> Apply to the footer element in the APEX 5 Universal Theme.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 119352534110469323 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 119352140149466561 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Footer Element'
 ,p_return_value => 'footer-tag'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 119352928719471821 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 119352140149466561 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'jQuery Selector'
 ,p_return_value => 'jquery-selector'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 119355429314779263 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 119352140149466561 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'UT Footer (APEX 5 UT only)'
 ,p_return_value => 'ut-footer'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 119353438195482609 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 119349149090340872 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 2
 ,p_display_sequence => 20
 ,p_prompt => 'jQuery Selector'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_default_value => 'footer'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 119352140149466561 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'jquery-selector'
 ,p_help_text => '<span class="instructiontext">'||unistr('\000a')||
'	<p>Application Express ships with the jQuery library. This offers a very powerful selector syntax which provides a way to easily access elements from a page. You can utilise this syntax here to return an element(s) that will be affected by the action. For example:'||unistr('\000a')||
'</p><ul>'||unistr('\000a')||
'  <li>#my_id - To select a page element with an ''ID'' of ''my_id''.</li>'||unistr('\000a')||
'  <li>.my_class - To select all the page elements with a class of ''my_class''.</li>'||unistr('\000a')||
'  <li>input - To select all the page elements that are inputs.</li>'||unistr('\000a')||
'</ul>'||unistr('\000a')||
'<p></p>'||unistr('\000a')||
'<p>There are many more selectors available, please see the jQuery official documentation available from the <a target="_blank" href="http://docs.jquery.com">jQuery homepage</a> for further information.</p></span>'
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2F206A51756572792E646F776E426F792E6175746F2E6D696E20312E320A66756E6374696F6E20646F776E426F7928666F6F746572297B2775736520737472696374273B666F6F7465723D666F6F7465727C7C27666F6F746572273B2428666F6F7465';
wwv_flow_api.g_varchar2_table(2) := '72292E6373732827706F736974696F6E272C2727292E6373732827626F74746F6D272C2727293B696628242877696E646F77292E68656967687428293E242827626F647927292E6865696768742829297B2428666F6F746572292E6373732827706F7369';
wwv_flow_api.g_varchar2_table(3) := '74696F6E272C276162736F6C75746527292E6373732827626F74746F6D272C273027297D7D242866756E6374696F6E28297B646F776E426F7928293B77696E646F772E6F6E726573697A653D66756E6374696F6E28297B646F776E426F7928297D7D290A';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 119349954126374938 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 119349149090340872 + wwv_flow_api.g_id_offset
 ,p_file_name => 'jquery.downboy.auto.min.js'
 ,p_mime_type => 'application/javascript'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

 
begin
 
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2F206A51756572792E646F776E426F792E6D696E20312E320A66756E6374696F6E20646F776E426F7928666F6F746572297B2775736520737472696374273B666F6F7465723D666F6F7465727C7C27666F6F746572273B2428666F6F746572292E6373';
wwv_flow_api.g_varchar2_table(2) := '732827706F736974696F6E272C2727292E6373732827626F74746F6D272C2727293B696628242877696E646F77292E68656967687428293E242827626F647927292E6865696768742829297B2428666F6F746572292E6373732827706F736974696F6E27';
wwv_flow_api.g_varchar2_table(3) := '2C276162736F6C75746527292E6373732827626F74746F6D272C273027297D7D0A';
null;
 
end;
/

 
begin
 
wwv_flow_api.create_plugin_file (
  p_id => 119350642000376623 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 119349149090340872 + wwv_flow_api.g_id_offset
 ,p_file_name => 'jquery.downboy.min.js'
 ,p_mime_type => 'application/javascript'
 ,p_file_content => wwv_flow_api.g_varchar2_table
  );
null;
 
end;
/

commit;
begin
execute immediate 'begin sys.dbms_session.set_nls( param => ''NLS_NUMERIC_CHARACTERS'', value => '''''''' || replace(wwv_flow_api.g_nls_numeric_chars,'''''''','''''''''''') || ''''''''); end;';
end;
/
set verify on
set feedback on
set define on
prompt  ...done
